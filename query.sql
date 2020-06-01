-- BMIS441; Group 2
-- Final Project
-- 11/19/19
-- final_build.sql

-- 1. What is the pay rate of current deliver trucks drivers?
SELECT (first_name || ' ' || last_name) AS Name, '$' || payrate AS Payrate
FROM  employee
WHERE driver = 'Y';

-- 2. What beers have an ABV greater than 6.5 but cost less than 60 dollars to brew?
SELECT name, alc_lvl || '%' AS ABV, '$' || cost AS Cost
FROM item
WHERE alc_lvl > 6.5
AND cost < 60.0;
