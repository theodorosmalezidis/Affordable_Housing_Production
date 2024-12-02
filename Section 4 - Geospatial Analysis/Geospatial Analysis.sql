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

with borough_total_units as (
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
    nta_total_units_perc DESC


/*i have to right insights for that : Insights This Query Can Provide

    Contribution Analysis:
        This query identifies how much each NTA contributes to the overall housing stock in its respective borough.
        Insight Example: If one or two NTAs dominate the housing stock, it may indicate unequal distribution of resources or projects within the borough.

    Identify Dominant NTAs:
        It can highlight NTAs with disproportionately high housing contributions.
        Insight Example: An NTA with a very high percentage might be a key focus area for housing development or an over-concentrated region.

    Policy Planning:
        Policymakers can use this information to ensure equitable distribution of housing projects across NTAs within a borough.
        Insight Example: If certain NTAs contribute very little, it could indicate an underserved area requiring more attention.

    Prioritization of Resources:
        Boroughs can identify NTAs with low percentages to prioritize future developments or investigate barriers to housing projects in those areas.
        Insight Example: An NTA with less than 5% of the borough's units might signal a need for targeted investment.

    Comparison Across Boroughs:
        By analyzing percentages, you can compare how evenly housing units are distributed within each borough.
        Insight Example: If one borough has more balanced contributions across NTAs compared to others, it may suggest better housing policies or planning practices.*/


--  Which a)income types and b)bedroom categories do neighborhoods focus on, based on the percentage of housing units?"

--a) income types


WITH nta_income_units AS (
    SELECT
        nta_neighborhood_tabulation_area,
        SUM(extremely_low_income_units) AS extremely_low_income_units_total,
        SUM(very_low_income_units) AS very_low_income_units_total,
        SUM(low_income_units) AS low_income_units_total,
        SUM(moderate_income_units) AS moderate_income_units_total,
        SUM(middle_income_units) AS middle_income_units_total,
        SUM(other_income_units) AS other_income_units_total,
        SUM(all_counted_units) AS total_units_sum
    FROM
        affordable_housing_production
    GROUP BY
        nta_neighborhood_tabulation_area
),
nta_income_percentage AS (
    SELECT
        nta_neighborhood_tabulation_area,
        extremely_low_income_units_total,
        very_low_income_units_total,
        low_income_units_total,
        moderate_income_units_total,
        middle_income_units_total,
        other_income_units_total,
        total_units_sum,
        ROUND((extremely_low_income_units_total * 100.0 / total_units_sum), 2) AS extremely_low_income_perc,
        ROUND((very_low_income_units_total * 100.0 / total_units_sum), 2) AS very_low_income_perc,
        ROUND((low_income_units_total * 100.0 / total_units_sum), 2) AS low_income_perc,
        ROUND((moderate_income_units_total * 100.0 / total_units_sum), 2) AS moderate_income_perc,
        ROUND((middle_income_units_total * 100.0 / total_units_sum), 2) AS middle_income_perc,
        ROUND((other_income_units_total * 100.0 / total_units_sum), 2) AS other_income_perc
    FROM
        nta_income_units
)
SELECT
    nta_neighborhood_tabulation_area,
    extremely_low_income_perc,
    very_low_income_perc,
    low_income_perc,
    moderate_income_perc,
    middle_income_perc,
    other_income_perc
FROM
    nta_income_percentage
ORDER BY
    nta_neighborhood_tabulation_area;



--b) bedroom categories


WITH nta_br_units AS (
    SELECT
        nta_neighborhood_tabulation_area,
        SUM(studio_units) AS studio_total,
        SUM(one_br_units) AS one_br_total,
        SUM(two_br_units) AS two_br_total,
        SUM(three_br_units) AS three_br_total,
        SUM(four_br_units) AS four_br_total,
        SUM(five_br_units) AS five_br_total,
        SUM(six_br_plus_units) AS six_br_plus_total,
        SUM(unknown_br_units) AS unknown_br_total,
        SUM(all_counted_units) AS total_units_sum
    FROM
        affordable_housing_production
    GROUP BY
        nta_neighborhood_tabulation_area
),
nta_br_percentage AS (
    SELECT
        nta_neighborhood_tabulation_area,
        studio_total,
        one_br_total,
        two_br_total,
        three_br_total,
        four_br_total,
        five_br_total,
        six_br_plus_total,
        unknown_br_total,
        total_units_sum,
        ROUND((studio_total * 100.0 / total_units_sum), 2) AS studio_total_perc,
        ROUND((one_br_total * 100.0 / total_units_sum), 2) AS one_br_total_perc,
        ROUND((two_br_total * 100.0 / total_units_sum), 2) AS two_br_total_perc,
        ROUND((three_br_total * 100.0 / total_units_sum), 2) AS three_br_total_perc,
        ROUND((four_br_total * 100.0 / total_units_sum), 2) AS four_br_total_perc,
        ROUND((five_br_total * 100.0 / total_units_sum), 2) AS five_br_total_perc,
        ROUND((six_br_plus_total * 100.0 / total_units_sum), 2) AS six_br_plus_total_perc,
        ROUND((unknown_br_total * 100.0 / total_units_sum), 2) AS unknown_br_total_perc,
        ROUND((total_units_sum * 100.0 / total_units_sum), 2) AS total_units_sum_perc
    FROM
        nta_br_units
)
SELECT
    nta_neighborhood_tabulation_area,
    studio_total_perc,
    one_br_total_perc,
    two_br_total_perc,
    three_br_total_perc,
    four_br_total_perc,
    five_br_total_perc,
    six_br_plus_total_perc,
    unknown_br_total_perc
FROM
    nta_br_percentage
ORDER BY
    nta_neighborhood_tabulation_area;