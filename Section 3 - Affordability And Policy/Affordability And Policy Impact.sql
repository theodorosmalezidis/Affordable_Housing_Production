-- AFFORDABILLITY AND POLICY IMPACT

-- 1.Extended Affordability


-- How many projects are listed under "Extended Affordability Only"?

SELECT
    COUNT(CASE
            WHEN extended_affordability_only='Yes' THEN 1 END ) AS extended_affordabillity_only_projects
FROM
    affordable_housing_production;



-- Are these projects concentrated in specific boroughs ?


SELECT
    borough,
    COUNT(CASE
            WHEN extended_affordability_only='Yes' THEN 1 END ) AS extended_affordabillity_only_projects
FROM
    affordable_housing_production
GROUP BY
    borough
ORDER BY
    extended_affordabillity_only_projects DESC;

--  How Extended Affordability correlates with the Reporting Construction Type

SELECT
    reporting_construction_type,
    COUNT(*) AS total_projects,
    (SUM(CASE WHEN extended_affordability_only='Yes' THEN 1 ELSE 0 END)) * 100/ COUNT(*) AS extended_affordability_only_perc,
    (SUM(CASE WHEN extended_affordability_only='No' THEN 1 ELSE 0 END)) * 100/ COUNT(*) AS non_extended_affordability_only_perc
FROM
    affordable_housing_production
GROUP BY
    reporting_construction_type;


--2. Prevailing Wage Impact


-- 	How many projects follow "Prevailing Wage Status" ?


SELECT
    COUNT(*) AS total_projects,
    COUNT(CASE WHEN prevailing_wage_status = 'Prevailing Wage' THEN 1 END) AS prevailing_wage_projects
FROM
    affordable_housing_production;



--	Are certain income categories more prevalent in prevailing wage projects? ( wage requirements affect targeting of income levels?)


   
 WITH all_categories_units AS(
    SELECT
        prevailing_wage_status,
        SUM(all_counted_units) AS total_units
    FROM
        affordable_housing_production
    WHERE
       prevailing_wage_status='Prevailing Wage' 
    GROUP BY
        prevailing_wage_status
 )
 SELECT
    a.prevailing_wage_status,
    ROUND((SUM(a.extremely_low_income_units) * 100.0) / b.total_units, 3) AS extremely_low_income_units_perc,
    ROUND((SUM(a.very_low_income_units) * 100.0) / b.total_units, 3) AS very_low_income_units_perc,
    ROUND((SUM(a.low_income_units) * 100.0) / b.total_units, 3) AS low_income_units_perc,
    ROUND((SUM(a.moderate_income_units) * 100.0) / b.total_units, 3) AS moderate_income_units_perc,
    ROUND((SUM(a.middle_income_units) * 100.0) / b.total_units, 3) AS middle_income_units_perc,
    ROUND((SUM(a.other_income_units) * 100.0) / b.total_units, 3) AS other_income_units_perc
FROM
    affordable_housing_production a
JOIN
    all_categories_units b ON a.prevailing_wage_status=b.prevailing_wage_status
GROUP BY
    a.prevailing_wage_status,
    b.total_units;
