-- 1. In accounts table, there is a column holding website for each company. Last three digitss scpicify what type of web address they are using.
--    Pull these extensions and provide how many of each website type exist.


-- 2. Pull first letter of each company name to see distribution of company names that begin with each letter.


-- 3. Use accounts table and CASE statement có create two groups: one of company names that start with a number and one of company names that start with a letter. 
--    What proportion of company names that begin with a letter?


-- 4. What proportion of company names start with a vowel?


-- 5. Display concatenated sales_reps.id, ‘_’, and region.name as EMP_ID_REGION


-- 6. From accounts table, display name of client, coordinate as concatenated (latitude, longitude), email id of primary point contact as
--    <first letter of primary_poc><last letter of primary_poc>@<extracted name and domain from website>


-- 7. From web_events table, display concatenated value of account_id, ‘_’, channel, ‘_’, count of web events of particular channel


-- 8. Use accounts table to create first and last name columns for primary_loc.


-- 9. Do same thing for every rep name in sales_rep table


-- 10. From accounts table, create email address which is first name of primary_proc . last name primary_poc @ company_name . com


-- 11. Remove space in email addresses above


-- 12. Create initial password, which will be first letter of primary_poc’s first name (lowercase), then last letter of their first name (lowercase),
--     first letter of their last name (lowercase), last letter of their last name (lowercase), number of letters in their first name,
--     number of letters in their last name, and then name of company they are working with, all capitalized with no spaces.