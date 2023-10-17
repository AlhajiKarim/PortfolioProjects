
--Retrieving the Whole Dataset
Select * from dbo.All_Market_Data

-- New market for specific types
Select * 
from dbo.All_Market_Data
where new_type = 'type_1' and new_market = 'market_2'


-- Calculate the total number of calls and the number of repeat calls
SELECT
    COUNT(*) AS TotalCalls,
    SUM(CASE WHEN contacts_n > 0 THEN 1 ELSE 0 END) AS RepeatCalls
FROM
    dbo.All_Market_Data;


-- Count repeat calls by problem type
SELECT
    contacts_n,
    SUM(CASE WHEN contacts_n > 0 THEN 1 ELSE 0 END) AS RepeatCalls
FROM
    dbo.All_Market_Data
GROUP BY
    contacts_n
ORDER BY
    RepeatCalls DESC;

-- Count repeat calls by market city
SELECT
    new_market,
    SUM(CASE WHEN contacts_n > 0 THEN 1 ELSE 0 END) AS RepeatCalls
FROM
    dbo.All_Market_Data
GROUP BY
    new_market
ORDER BY
    RepeatCalls DESC;


--How Many Times Customer Team receive a repeat call from Customer

SELECT COUNT(*) AS repeat_calls_count
FROM dbo.All_Market_Data
WHERE contacts_n > 1;


--Problem type that generate most calls

SELECT new_type AS problem_type, COUNT(*) AS repeat_calls_count
FROM dbo.All_Market_Data
WHERE contacts_n > 1
GROUP BY new_type
ORDER BY repeat_calls_count DESC;


--Market City Customer Service Team with the most repeat calls

SELECT new_market AS market_city, COUNT(*) AS repeat_calls_count
FROM dbo.All_Market_Data
WHERE contacts_n > 1
GROUP BY new_market
ORDER BY repeat_calls_count DESC;

--How ofter do customers call support after first inquiry

SELECT 
    (SUM(CASE WHEN contacts_n > 1 THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS repeat_call_percentage
FROM dbo.All_Market_Data;


--Customer Issue that generates the most repeat calls

SELECT
    new_type AS problem_type,
    COUNT(*) AS total_calls,
    SUM(CASE WHEN contacts_n > 1 THEN 1 ELSE 0 END) AS repeat_calls,
    (SUM(CASE WHEN contacts_n > 1 THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS repeat_call_percentage
FROM dbo.All_Market_Data
GROUP BY new_type
ORDER BY repeat_call_percentage DESC;


--Repeat call trends in the three different market cities

SELECT
    new_market AS market_city,
    DATEPART(WK, date_created) AS week,
    DATEPART(MONTH, date_created) AS month,
    (DATEPART(QUARTER, date_created) + 1) AS quarter,
    DATEPART(YEAR, date_created) AS year,
    COUNT(*) AS total_calls,
    SUM(CASE WHEN contacts_n > 1 THEN 1 ELSE 0 END) AS repeat_calls
FROM dbo.All_Market_Data
GROUP BY new_market, DATEPART(WK, date_created), DATEPART(MONTH, date_created), DATEPART(QUARTER, date_created), DATEPART(YEAR, date_created)
ORDER BY market_city, year, quarter, month, week;

