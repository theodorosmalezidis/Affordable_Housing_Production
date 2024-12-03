--PROJECT OVERVIEW

--1.Project Statistics

--	How many housing projects have been completed and how many were ongoing or have missing completion dates??


SELECT 
    COUNT(CASE WHEN project_completion_date IS NOT NULL THEN 1 END) AS completed_projects,
    COUNT(CASE WHEN project_completion_date IS NULL THEN 1 END) AS uncompleted_projects
FROM
    affordable_housing_production;



--  What is the number of units per project?

SELECT
    project_id,
    SUM(all_counted_units) AS total_units_per_project
FROM
    affordable_housing_production
GROUP BY
    project_id
ORDER BY
    total_units_per_project DESC


-- What is the average number of units per project?

SELECT
    ROUND(AVG(total_units), 2) AS average_units_per_project
FROM (
    SELECT 
        project_id,
        SUM(all_counted_units) AS total_units
    FROM
        affordable_housing_production
    GROUP BY
        project_id
) AS avg_total;


-- How many projects are associated with each project id?

SELECT
    project_id,
    COUNT(*) AS number_of_projects
FROM
    affordable_housing_production
GROUP BY
    project_id
ORDER BY
    number_of_projects DESC


--2. PROJECT DISTRIBUTION


--	What is the distribution of projects across boroughs



SELECT
    borough,
    COUNT(*) AS number_of_projects
FROM
    affordable_housing_production
GROUP BY
    borough
ORDER BY
    number_of_projects DESC;

-- 	Which borough has the highest number of projects completed?

SELECT
    borough,
    COUNT(CASE WHEN project_completion_date IS NOT NULL THEN 1 END) AS completed_projects
FROM
    affordable_housing_production
GROUP BY
    borough
ORDER BY
    completed_projects DESC


--3. CONSTRUCTION TYPES

-- 	How many projects are categorized under each "Reporting Construction Type"? What is the most common construction type for affordable housing?

SELECT
    reporting_construction_type,
    COUNT(*)
FROM
    affordable_housing_production
GROUP BY
    reporting_construction_type

