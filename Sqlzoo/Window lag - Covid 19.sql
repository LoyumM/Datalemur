-- 1.The example uses a WHERE clause to show the cases in 'Italy' in March 2020.
-- Modify the query to show data from Spain

SELECT name, DAY(whn),
    confirmed, deaths, recovered
FROM covid
WHERE name = 'Spain'
    AND MONTH(whn) = 3 AND YEAR(whn) = 2020
ORDER BY whn;

-- 2. The LAG function is used to show data from the preceding row or the table. 
-- When lining up rows the data is partitioned by country name and ordered by the 
-- data whn. That means that only data from Italy is considered.
-- Modify the query to show confirmed for the day before.

SELECT name, DAY(whn) AS day, confirmed,
    LAG(confirmed, 1) OVER (PARTITION BY name ORDER BY whn) AS previous_day
FROM covid
WHERE name = 'Italy'
    AND MONTH(whn) = 3 AND YEAR(whn) = 2020
ORDER BY whn;

-- 3. The number of confirmed case is cumulative - but we can use LAG to recover the 
-- number of new cases reported for each day.
-- Show the number of new cases for each day, for Italy, for March.

SELECT name, DAY(whn) AS day,
    confirmed - LAG(confirmed, 1) OVER (PARTITION BY name ORDER BY whn) AS new
FROM covid
WHERE name = 'Italy'
    AND MONTH(whn) = 3 AND YEAR(whn) = 2020
ORDER BY whn;

-- 4.The data gathered are necessarily estimates and are inaccurate. However by taking a longer time span we can mitigate some of the effects.
-- You can filter the data to view only Monday's figures WHERE WEEKDAY(whn) = 0.
-- Show the number of new cases in Italy for each week in 2020 - show Monday only.

-- In MySQL:
SELECT name, DATE_FORMAT(whn,'%Y-%m-%d') AS date,
    (confirmed - LAG(confirmed, 1) OVER (PARTITION BY name ORDER BY whn)) AS week_count
FROM covid
WHERE (name = 'Italy')
    AND (WEEKDAY(whn) = 0)
    AND year(whn) = 2020
ORDER BY whn;

-- In MicrosoftSQL:
SELECT name, FORMAT(whn,'yyyy-MM-dd') AS date,
    (confirmed - LAG(confirmed, 1) OVER (PARTITION BY name ORDER BY whn)) AS week_count
FROM covid
WHERE (name = 'Italy')
    AND (DATEPART(WEEKDAY, whn) = 2)
    AND year(whn) = 2020
ORDER BY whn;