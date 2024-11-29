-- 1. Create a running total of standard_amt_usd over order time with no date truncation.
--    Final table should have two columns: one with amount being added for each new row, and second with running total.


-- 2. Như trên, nhưng lần này dùng date truncate cho occurred_at by year and partition by that same year-truncated occurred_at variable.
--    Final table show have three columns: one with amount being added for each row, one for truncated date, one with running total within each year.


-- 3. Aggregates sum, count, avg, min, max của standard_qty


-- 4. Select id, account_id, total from orders table, then create a column called total_rank that ranks this total amount of paper ordered (from highest to lowest) for each account using a partition.


-- 5. Viết lại 3 nhưng thay đoạn (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at)) bằng alias WINDOW


-- 6. LAG and LEAD


 -- 7. Use NTILE to divide accounts into 4 levels in terms of amount of standard_qty for their orders. Resulting table should have
 --   account_id, occurred_at time for each order, total amount of standard_sqty paper purchased, and one of 4 levels in a standard_quartile column.


-- 8. Use NTILE to divide accounts into two levels in terms of amount of gloss_qty for their orders. Resulting table should have
--    account_id, occurred_at time for each order, total amount of gloss_qty paper purchased, and one of two levels in gloss_half column.


-- 9. Use NTILE to divide orders for each account into 100 levels in terms of amount of total_amt_usd for their orders. Resulting table should have
--    account_id, orcurred_at time for each order, total amount of total_amt_usd paper purchased, and one of 100 levels in a total_percentile column.