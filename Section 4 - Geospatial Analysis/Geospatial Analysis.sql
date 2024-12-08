-- GEOSPATIAL ANALYSIS

-- 1. Neighborhood Trends

-- What are the top 10 neighborhoods (Neighborhood Tabulation Areas) with the most units and to which borough are they located?

SELECT
    nta_neighborhood_tabulation_area,
    borough,
    SUM(all_counted_units) AS nta_total_units
FROM
    affordable_housing_production
GROUP BY
    nta_neighborhood_tabulation_area,
    borough
ORDER BY
    nta_total_units DESC
LIMIT 10;

--What percentage of each borough's total housing units is provided by its Neighborhood Tabulation Areas (NTAs)?

With borough_total_units as (
    SELECT
        borough,
        SUM(all_counted_units) AS borough_total_units_sum
    FROM affordable_housing_production
    GROUP BY borough
),
nta_total_units as(
    SELECT 
        borough,
        nta_neighborhood_tabulation_area,
        SUM(all_counted_units) AS nta_total_units
    FROM affordable_housing_production
    GROUP BY
        nta_neighborhood_tabulation_area,
        borough
)
SELECT 
    borough_total_units.borough,
    nta_total_units.nta_neighborhood_tabulation_area,
    (nta_total_units * 100) / borough_total_units_sum AS nta_total_units_perc
FROM
    borough_total_units
JOIN
    nta_total_units on borough_total_units.borough = nta_total_units.borough
ORDER BY
    borough_total_units.borough,
    nta_total_units_perc DESC;



--  Which a)income types and b)bedroom categories do neighborhoods focus on, based on the percentage of housing units?"

--a) income types


SELECT
    nta_neighborhood_tabulation_area,
    ROUND((SUM(extremely_low_income_units) * 100.0 / SUM(all_counted_units)), 2) AS extremely_low_income_perc,
    ROUND((SUM(very_low_income_units) * 100.0 / SUM(all_counted_units)), 2) AS very_low_income_perc,
    ROUND((SUM(low_income_units) * 100.0 / SUM(all_counted_units)), 2) AS low_income_perc,
    ROUND((SUM(moderate_income_units) * 100.0 / SUM(all_counted_units)), 2) AS moderate_income_perc,
    ROUND((SUM(middle_income_units) * 100.0 / SUM(all_counted_units)), 2) AS middle_income_perc,
    ROUND((SUM(other_income_units) * 100.0 / SUM(all_counted_units)), 2) AS other_income_perc
FROM
    affordable_housing_production
GROUP BY
    nta_neighborhood_tabulation_area
ORDER BY
    nta_neighborhood_tabulation_area;



--b) bedroom categories

SELECT
    nta_neighborhood_tabulation_area,
    ROUND((SUM(extremely_low_income_units) * 100.0 / SUM(all_counted_units)), 2) AS extremely_low_income_perc,
    ROUND((SUM(very_low_income_units) * 100.0 / SUM(all_counted_units)), 2) AS very_low_income_perc,
    ROUND((SUM(low_income_units) * 100.0 / SUM(all_counted_units)), 2) AS low_income_perc,
    ROUND((SUM(moderate_income_units) * 100.0 / SUM(all_counted_units)), 2) AS moderate_income_perc,
    ROUND((SUM(middle_income_units) * 100.0 / SUM(all_counted_units)), 2) AS middle_income_perc,
    ROUND((SUM(other_income_units) * 100.0 / SUM(all_counted_units)), 2) AS other_income_perc
FROM
    affordable_housing_production
GROUP BY
    nta_neighborhood_tabulation_area
ORDER BY
    nta_neighborhood_tabulation_area;
