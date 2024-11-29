-- 1. In accounts table, there is a column holding website for each company. Last three digitss scpicify what type of web address they are using.
--    Pull these extensions and provide how many of each website type exist.
SELECT RIGHT(website, 3) AS domain, COUNT(*) num_companies
FROM accounts
GROUP BY 1
ORDER BY 2 DESC;


-- 2. Pull first letter of each company name to see distribution of company names that begin with each letter.
SELECT LEFT(UPPER(name), 1) AS first_letter, COUNT(*) num_companies
FROM accounts
GROUP BY 1
ORDER BY 2 DESC;


-- 3. Use accounts table and CASE statement có create two groups: one of company names that start with a number and one of company names that start with a letter. 
--    What proportion of company names that begin with a letter?
SELECT SUM(num) nums, SUM(letter) letters
FROM (SELECT name, CASE WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9') 
                          THEN 1 ELSE 0 END AS num, 
            CASE WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9') 
                          THEN 0 ELSE 1 END AS letter
         FROM accounts) t1;


-- 4. What proportion of company names start with a vowel?
SELECT SUM(vowels) vowels, SUM(other) other
FROM (SELECT name, CASE WHEN LEFT(UPPER(name), 1) IN ('A','E','I','O','U') 
                           THEN 1 ELSE 0 END AS vowels, 
             CASE WHEN LEFT(UPPER(name), 1) IN ('A','E','I','O','U') 
                          THEN 0 ELSE 1 END AS other
            FROM accounts) t1;


-- 5. Display concatenated sales_reps.id, ‘_’, and region.name as EMP_ID_REGION
SELECT CONCAT(SALES_REPS.ID, '_', REGION.NAME) EMP_ID_REGION, SALES_REPS.NAME
FROM SALES_REPS
JOIN REGION
ON SALES_REPS.REGION_ID = REGION_ID;


-- 6. From accounts table, display name of client, coordinate as concatenated (latitude, longitude), email id of primary point contact as
--    <first letter of primary_poc><last letter of primary_poc>@<extracted name and domain from website>
SELECT NAME, CONCAT(LAT, ', ', LONG) COORDINATE,
			 CONCAT(LEFT(PRIMARY_POC, 1), RIGHT(PRIMARY_POC, 1), '@', SUBSTR(WEBSITE, 5)) EMAIL
FROM ACCOUNTS;


-- 7. From web_events table, display concatenated value of account_id, ‘_’, channel, ‘_’, count of web events of particular channel
WITH T1 AS (
    SELECT ACCOUNT_ID, CHANNEL, COUNT(*) 
    FROM WEB_EVENTS
    GROUP BY ACCOUNT_ID, CHANNEL
    ORDER BY ACCOUNT_ID
)
SELECT CONCAT(T1.ACCOUNT_ID, '_', T1.CHANNEL, '_', COUNT)
FROM T1;


-- 8. Use accounts table to create first and last name columns for primary_loc.
SELECT LEFT(primary_poc, STRPOS(primary_poc, ' ') -1 ) first_name, 
   RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name
FROM accounts;


-- 9. Do same thing for every rep name in sales_rep table
SELECT LEFT(name, STRPOS(name, ' ') -1 ) first_name, 
          RIGHT(name, LENGTH(name) - STRPOS(name, ' ')) last_name
FROM sales_reps;


-- 10. From accounts table, create email address which is first name of primary_proc . last name primary_poc @ company_name . com
WITH t1 AS (
    SELECT LEFT(primary_poc,     STRPOS(primary_poc, ' ') -1 ) first_name,
			     RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name, name
    FROM accounts)
SELECT first_name, last_name, CONCAT(first_name, '.', last_name, '@', name, '.com')
FROM t1;


-- 11. Remove space in email addresses above
WITH t1 AS (
    SELECT LEFT(primary_poc,     STRPOS(primary_poc, ' ') -1 ) first_name,
			     RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name, name
    FROM accounts)
SELECT first_name, last_name, CONCAT(first_name, '.', last_name, '@', REPLACE(name, ' ', ''), '.com')
FROM  t1;


-- 12. Create initial password, which will be first letter of primary_poc’s first name (lowercase), then last letter of their first name (lowercase),
--     first letter of their last name (lowercase), last letter of their last name (lowercase), number of letters in their first name,
--     number of letters in their last name, and then name of company they are working with, all capitalized with no spaces.
WITH t1 AS (
    SELECT LEFT(primary_poc, STRPOS(primary_poc, ' ') -1 ) first_name,
    RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name, name
    FROM accounts)
SELECT first_name, last_name, CONCAT(first_name, '.', last_name, '@', name, '.com'),
			 LEFT(LOWER(first_name), 1) || RIGHT(LOWER(first_name), 1) ||
			 LEFT(LOWER(last_name), 1) || RIGHT(LOWER(last_name), 1) ||
			 LENGTH(first_name) || LENGTH(last_name) || REPLACE(UPPER(name), ' ', '')
FROM t1;