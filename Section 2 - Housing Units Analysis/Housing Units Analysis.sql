--HOUSING YNITS ANALYSIS


--1. Income-Based Units


--  What is the distribution of housing units by income type (e.g., Extremely Low Income, Low Income)?




SELECT
    SUM(extremely_low_income_units) AS extremely_low_income_units_total,
    SUM(very_low_income_units) AS very_low_income_units_total,
    SUM(low_income_units) AS low_income_units_total,
    SUM(moderate_income_units) AS moderate_income_units_total,
    SUM(middle_income_units) AS middle_income_units_total,
    SUM(other_income_units) AS other_income_units_total
FROM
    affordable_housing_production


-- And by percentage the share of each income type in the total housing units?

WITH Total_Units AS (
    SELECT
        SUM(extremely_low_income_units) AS extremely_low_income_units_total,
        SUM(very_low_income_units) AS very_low_income_units_total,
        SUM(low_income_units) AS low_income_units_total,
        SUM(moderate_income_units) AS moderate_income_units_total,
        SUM(middle_income_units) AS middle_income_units_total,
        SUM(other_income_units) AS other_income_units_total
    FROM
        affordable_housing_production
)
SELECT
    ROUND((extremely_low_income_units_total * 100.0) / (
        extremely_low_income_units_total +
        very_low_income_units_total +
        low_income_units_total +
        moderate_income_units_total +
        middle_income_units_total +
        other_income_units_total
    ), 2) AS extremely_low_income_percentage,
    ROUND((very_low_income_units_total * 100.0) / (
        extremely_low_income_units_total +
        very_low_income_units_total +
        low_income_units_total +
        moderate_income_units_total +
        middle_income_units_total +
        other_income_units_total
    ), 2) AS very_low_income_percentage,
    ROUND((low_income_units_total * 100.0) / (
        extremely_low_income_units_total +
        very_low_income_units_total +
        low_income_units_total +
        moderate_income_units_total +
        middle_income_units_total +
        other_income_units_total
    ), 2) AS low_income_percentage,
    ROUND((moderate_income_units_total * 100.0) / (
        extremely_low_income_units_total +
        very_low_income_units_total +
        low_income_units_total +
        moderate_income_units_total +
        middle_income_units_total +
        other_income_units_total
    ), 2) AS moderate_income_percentage,
    ROUND((middle_income_units_total * 100.0) / (
        extremely_low_income_units_total +
        very_low_income_units_total +
        low_income_units_total +
        moderate_income_units_total +
        middle_income_units_total +
        other_income_units_total
    ), 2) AS middle_income_percentage,
    ROUND((other_income_units_total * 100.0) / (
        extremely_low_income_units_total +
        very_low_income_units_total +
        low_income_units_total +
        moderate_income_units_total +
        middle_income_units_total +
        other_income_units_total
    ), 2) AS other_income_percentage
FROM Total_Units;


-- 	Which borough provides the most units for each income group?



WITH IncomeGroupRanking AS (
    SELECT
        borough,
        SUM(extremely_low_income_units) AS extremely_low_income_units_total,
        SUM(very_low_income_units) AS very_low_income_units_total,
        SUM(low_income_units) AS low_income_units_total,
        SUM(moderate_income_units) AS moderate_income_units_total,
        SUM(middle_income_units) AS middle_income_units_total,
        SUM(other_income_units) AS other_income_units_total
    FROM
        affordable_housing_production
    GROUP BY
        borough
),
RankedBoroughs AS (
    SELECT
        borough,
        'Extremely Low Income' AS income_group,
        extremely_low_income_units_total AS units,
        ROW_NUMBER() OVER (ORDER BY extremely_low_income_units_total DESC) AS rank
    FROM IncomeGroupRanking
    UNION ALL
    SELECT
        borough,
        'Very Low Income' AS income_group,
        very_low_income_units_total AS units,
        ROW_NUMBER() OVER (ORDER BY very_low_income_units_total DESC)
    FROM IncomeGroupRanking
    UNION ALL
    SELECT
        borough,
        'Low Income' AS income_group,
        low_income_units_total AS units ,
        ROW_NUMBER() OVER (ORDER BY low_income_units_total DESC)
    FROM IncomeGroupRanking
    UNION ALL
    SELECT
        borough,
        'Moderate Income' AS income_group,
        moderate_income_units_total AS units,
        ROW_NUMBER() OVER (ORDER BY moderate_income_units_total DESC)
    FROM IncomeGroupRanking
    UNION ALL
    SELECT
        borough,
        'Middle Income' AS income_group,
        middle_income_units_total AS units,
        ROW_NUMBER() OVER (ORDER BY middle_income_units_total DESC)
    FROM IncomeGroupRanking
    UNION ALL
    SELECT
        borough,
        'Other Income' AS income_group,
        other_income_units_total AS units,
        ROW_NUMBER() OVER (ORDER BY other_income_units_total DESC)
    FROM IncomeGroupRanking
)
SELECT
    income_group,
    borough,
    units
FROM
    RankedBoroughs
WHERE
    rank = 1


-- What are the top 5 projects by units for each borough?

WITH ranking_projects AS(
    SELECT
        borough,
        project_id,
        COUNT(all_counted_units) AS total_counted_units,
        ROW_NUMBER() OVER(PARTITION BY borough ORDER BY COUNT(all_counted_units) DESC) AS rank
    FROM
        affordable_housing_production
    GROUP BY
        borough,
        project_id
)
SELECT
    borough,
    project_id,
    rank,
    total_counted_units
FROM    
     ranking_projects
WHERE
    rank <=5



--2. Bedroom Breakdown


--  How many total units are available for each bedroom category?

SELECT
    SUM(studio_units) AS studio_sum,
    SUM(one_br_units) AS one_br_sum,
    SUM(two_br_units) AS two_br_sum,
    SUM(three_br_units) AS three_br_sum,
    SUM(four_br_units) AS four_br_sum,
    SUM(five_br_units) AS five_br_sum,
    SUM(six_br_plus_units) AS six_br_plus_sum,
    SUM(unknown_br_units) AS unknown_br_sum
FROM
    affordable_housing_production


-- What is the total number of studio, 1-BR, 2-BR, etc., units per project?



SELECT 
    project_id, 
    SUM(studio_units) AS studio_total,
    SUM(one_br_units) AS one_br_total,
    SUM(two_br_units) AS two_br_total,
    SUM(three_br_units) AS three_br_total,
    SUM(four_br_units) AS four_br_total,
    SUM(five_br_units) AS five_br_total,
    SUM(six_br_plus_units) AS six_br_plus_total,
    SUM(unknown_br_units) AS unknown_br_total
FROM
    affordable_housing_production 
GROUP BY
    project_id
ORDER BY
    studio_total,
    one_br_total,
    two_br_total,
    three_br_total,
    four_br_total,
    five_br_total,
    six_br_plus_total,
    unknown_br_total;

-- Which bedroom category has the highest number of units in each borough?


WITH BrUnitsRanking AS (
    SELECT
        borough,
        SUM(studio_units) AS studio_total,
        SUM(one_br_units) AS one_br_total,
        SUM(two_br_units) AS two_br_total,
        SUM(three_br_units) AS three_br_total,
        SUM(four_br_units) AS four_br_total,
        SUM(five_br_units) AS five_br_total,
        SUM(six_br_plus_units) AS six_br_plus_total,
        SUM(unknown_br_units) AS unknown_br_total
    FROM
        affordable_housing_production
    GROUP BY
        borough
),
RankedBoroughs AS (
    SELECT
        borough,
        'studio_units' AS br_group,
        studio_total AS units,
        ROW_NUMBER() OVER (ORDER BY studio_total DESC) AS rank
    FROM BrUnitsRanking
    UNION ALL
    SELECT
        borough,
        'one_br_units' AS br_group,
        one_br_total AS units,
        ROW_NUMBER() OVER (ORDER BY one_br_total DESC)
    FROM BrUnitsRanking
    UNION ALL
    SELECT
        borough,
        'two_br_units' AS br_group,
        two_br_total AS units ,
        ROW_NUMBER() OVER (ORDER BY two_br_total DESC)
    FROM BrUnitsRanking
    UNION ALL
    SELECT
        borough,
        'three_br_units' AS br_group,
        three_br_total AS units,
        ROW_NUMBER() OVER (ORDER BY three_br_total DESC)
    FROM BrUnitsRanking
    UNION ALL
    SELECT
        borough,
        'four_br_units' AS br_group,
        four_br_total AS units,
        ROW_NUMBER() OVER (ORDER BY four_br_total DESC)
    FROM BrUnitsRanking
    UNION ALL
    SELECT
        borough,
        'five_br_units' AS br_group,
        five_br_total AS units,
        ROW_NUMBER() OVER (ORDER BY five_br_total DESC)
    FROM BrUnitsRanking
    UNION ALL
    SELECT
        borough,
        'six_br_plus_units' AS br_group,
        six_br_plus_total AS units,
        ROW_NUMBER() OVER (ORDER BY six_br_plus_total DESC)
    FROM BrUnitsRanking
    UNION ALL
    SELECT
        borough,
        'unknown_br_units' AS br_group,
        unknown_br_total AS units,
        ROW_NUMBER() OVER (ORDER BY unknown_br_total DESC)
    FROM BrUnitsRanking 
)
SELECT
    br_group,
    borough,
    units
FROM
    RankedBoroughs
WHERE
    rank = 1



--3.Ownership and Rental Units:



-- How many rental and ownership units each borough has?(keep in mind there is some overlap here)

SELECT
    borough,
    SUM(counted_rental_units) AS counted_rental_units_total,
    SUM(counted_homeownership_units) AS counted_homeownership_units_total
FROM
    affordable_housing_production
GROUP BY
    borough;

