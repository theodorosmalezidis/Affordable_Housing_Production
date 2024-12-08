--Trends Over Time

--1.Temporal Trends


--	How many affordable housing projects were started each year

SELECT
    EXTRACT(YEAR FROM project_start_date) AS project_year,
    COUNT(*) AS number_of_projects
FROM
    affordable_housing_production
GROUP BY
    project_year
ORDER BY
    project_year;




--  Which years saw the highest and lowest number of project completions?

 SELECT
    EXTRACT(YEAR FROM project_completion_date) AS project_completion_year, 
    COUNT(*) AS number_of_projects
FROM
    affordable_housing_production
GROUP BY
    project_completion_year
ORDER BY
    project_completion_year;


--2.Completion Time Analysis


-- What is the average, minimum, and maximum project duration?

--a) maximum

SELECT
    project_id,
    (project_completion_date - project_start_date) AS project_duration_days
FROM
    affordable_housing_production
WHERE
    project_completion_date IS NOT NULL
ORDER BY
    project_duration_days DESC
LIMIT 1;

--b) minimum

SELECT
    project_id,
    (project_completion_date - project_start_date) AS project_duration_days
FROM
    affordable_housing_production
WHERE
    project_completion_date IS NOT NULL
ORDER BY
    project_duration_days ASC
LIMIT 1;

/*(I am unsure about the interpretation of these results)*/

--c)average

SELECT
    ROUND(AVG(project_completion_date - project_start_date), 0) AS average_completion_time_days
FROM
    affordable_housing_production
WHERE
    project_completion_date IS NOT NULL



--  Are certain construction types or boroughs associated with faster completions?

--a) boroughs

SELECT
    borough,
    ROUND(AVG(project_completion_date - project_start_date), 0) AS average_completion_time_days
FROM
    affordable_housing_production
WHERE
    project_completion_date IS NOT NULL
GROUP BY
    borough
ORDER BY
    average_completion_time_days DESC;


--b) construction types


SELECT
    reporting_construction_type,
    ROUND(AVG(project_completion_date - project_start_date), 0) AS average_completion_time_days
FROM
    affordable_housing_production
WHERE
    project_completion_date IS NOT NULL
GROUP BY
    reporting_construction_type
ORDER BY
    average_completion_time_days DESC;



--3.Annual Trends in Affordable Housing Production



--	How has the production of affordable housing units changed over time?( What is the total number of affordable units produced by year?)


SELECT
    EXTRACT(YEAR FROM project_start_date) AS project_year, 
    SUM(all_counted_units) AS total_affordable_units
FROM
    affordable_housing_production
GROUP BY
    project_year
ORDER BY
    project_year;





-- What are the top 3 boroughs with the most affordable housing projects each year?


WITH ranked_boroughs AS(
    SELECT
        borough,
        COUNT(*) AS total_projects,
        EXTRACT(YEAR FROM project_start_date) AS project_year,
        RANK() OVER(PARTITION BY EXTRACT(YEAR FROM project_start_date)ORDER BY COUNT(*) DESC) as rank
    FROM affordable_housing_production
    GROUP BY
        borough,
        EXTRACT(YEAR FROM project_start_date)
)
SELECT
    project_year,
    borough,
    total_projects
FROM
    ranked_boroughs
WHERE
    rank<=3
ORDER BY
    project_year,
    rank


-- How have the number of projects changed over time across all boroughs?


WITH year_projects AS (
    SELECT
        borough,
        EXTRACT(YEAR FROM project_start_date) AS project_year,
        COUNT(*) AS yearly_projects
    FROM
        affordable_housing_production
    GROUP BY
        borough,
        EXTRACT(YEAR FROM project_start_date)
)
SELECT
    borough,
    project_year,
    yearly_projects,
    LAG(yearly_projects) OVER (PARTITION BY borough ORDER BY project_year) AS previous_year_projects,
    (yearly_projects - LAG(yearly_projects) OVER (PARTITION BY borough ORDER BY project_year)) AS project_difference
FROM
    year_projects
ORDER BY
    borough,
    project_year;


-- what is the cumulative number of projects by borough over time?

SELECT
    borough,
    EXTRACT(YEAR FROM project_start_date) AS project_year,
    COUNT(*) AS yearly_projects,
    SUM(COUNT(*)) OVER (PARTITION BY borough ORDER BY EXTRACT(YEAR FROM project_start_date)) AS cumulative_projects
FROM
    affordable_housing_production
GROUP BY
    borough,
    EXTRACT(YEAR FROM project_start_date)
ORDER BY 
    borough,
    project_year;

