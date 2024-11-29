-- 1. Create a running total of standard_amt_usd over order time with no date truncation.
--    Final table should have two columns: one with amount being added for each new row, and second with running total.
SELECT standard_amt_usd,
       SUM(standard_amt_usd) OVER (ORDER BY occurred_at) AS running_total
FROM orders


-- 2. Như trên, nhưng lần này dùng date truncate cho occurred_at by year and partition by that same year-truncated occurred_at variable.
--    Final table show have three columns: one with amount being added for each row, one for truncated date, one with running total within each year.
SELECT standard_amt_usd,
       DATE_TRUNC('year', occurred_at) as year,
       SUM(standard_amt_usd) OVER (
			   PARTITION BY DATE_TRUNC('year', occurred_at)
	       ORDER BY occurred_at) AS running_total
FROM orders


-- 3. Aggregates sum, count, avg, min, max của standard_qty
SELECT id,
       account_id,
       standard_qty,
       DATE_TRUNC('month', occurred_at) AS month,
       DENSE_RANK() OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS dense_rank,
       SUM(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS sum_std_qty,
       COUNT(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS count_std_qty,
       AVG(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS avg_std_qty,
       MIN(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS min_std_qty,
       MAX(standard_qty) OVER (PARTITION BY account_id ORDER BY DATE_TRUNC('month',occurred_at)) AS max_std_qty
FROM orders


-- 4. Select id, account_id, total from orders table, then create a column called total_rank that ranks this total amount of paper ordered (from highest to lowest) for each account using a partition.
SELECT id,
       account_id,
       total,
       RANK() OVER (PARTITION BY account_id ORDER BY total DESC) AS total_rank
FROM orders


-- 5. Viết lại 3 nhưng thay đoạn (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) bằng alias WINDOW
SELECT id,
       account_id,
       DATE_TRUNC('year',occurred_at) AS year,
       DENSE_RANK() OVER account_year_window AS dense_rank,
       total_amt_usd,
       SUM(total_amt_usd) OVER account_year_window AS sum_total_amt_usd,
       COUNT(total_amt_usd) OVER account_year_window AS count_total_amt_usd,
       AVG(total_amt_usd) OVER account_year_window AS avg_total_amt_usd,
       MIN(total_amt_usd) OVER account_year_window AS min_total_amt_usd,
       MAX(total_amt_usd) OVER account_year_window AS max_total_amt_usd
FROM orders 
WINDOW account_year_window AS (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at))


-- 6. LAG and LEAD
SELECT account_id,
       standard_sum,
       LAG(standard_sum) OVER (ORDER BY standard_sum) AS lag,
       LEAD(standard_sum) OVER (ORDER BY standard_sum) AS lead,
       standard_sum - LAG(standard_sum) OVER (ORDER BY standard_sum) AS lag_difference,
       LEAD(standard_sum) OVER (ORDER BY standard_sum) - standard_sum AS lead_difference
FROM (
SELECT account_id,
       SUM(standard_qty) AS standard_sum
  FROM orders 
 GROUP BY 1
 ) sub


 -- 7. Use NTILE to divide accounts into 4 levels in terms of amount of standard_qty for their orders. Resulting table should have
 --   account_id, occurred_at time for each order, total amount of standard_sqty paper purchased, and one of 4 levels in a standard_quartile column.
SELECT
       account_id,
       occurred_at,
       standard_qty,
       NTILE(4) OVER (PARTITION BY account_id ORDER BY standard_qty) AS standard_quartile
FROM orders 
ORDER BY account_id DESC


-- 8. Use NTILE to divide accounts into two levels in terms of amount of gloss_qty for their orders. Resulting table should have
--    account_id, occurred_at time for each order, total amount of gloss_qty paper purchased, and one of two levels in gloss_half column.
SELECT
       account_id,
       occurred_at,
       gloss_qty,
       NTILE(2) OVER (PARTITION BY account_id ORDER BY gloss_qty) AS gloss_half
FROM orders 
ORDER BY account_id DESC


-- 9. Use NTILE to divide orders for each account into 100 levels in terms of amount of total_amt_usd for their orders. Resulting table should have
--    account_id, orcurred_at time for each order, total amount of total_amt_usd paper purchased, and one of 100 levels in a total_percentile column.
SELECT
       account_id,
       occurred_at,
       total_amt_usd,
       NTILE(100) OVER (PARTITION BY account_id ORDER BY total_amt_usd) AS total_percentile
FROM orders 
ORDER BY account_id DESC