# TRENTS OVER TIME


## 1. Temporal Trends

- ### How many affordable housing projects were started each year?

```sql
SELECT
    EXTRACT(YEAR FROM project_start_date) AS project_year,
    COUNT(*) AS number_of_projects
FROM
    affordable_housing_production
GROUP BY
    project_year
ORDER BY
    project_year;
```

Results

![Number of Projects by Year](/Section%205%20-%20Trends%20Over%20Time/images/number_of_projects_by_year.png)

*Bar chart of Project started every year. This visualization was created with ChatGPT after importing my SQL query results*

- ### Which years saw the highest and lowest number of project completions?

```sql
 SELECT
    EXTRACT(YEAR FROM project_completion_date) AS project_completion_year, 
    COUNT(*) AS number_of_projects
FROM
    affordable_housing_production
GROUP BY
    project_completion_year
ORDER BY
    project_completion_year;
```

Results

![Completed Projects By Year](/Section%205%20-%20Trends%20Over%20Time/images/project_completion_years_bar_chart_with_numbers.png)

*Bar chart of Project Completed every year. This visualization was created with ChatGPT after importing my SQL query results*

So, 2019 was the year with the highest number of complete projects with 804, 2015 with the lowest 249 and 1633 projects are yet to be completed.

## 2. Completion Time Analysis

- ### What is the average, minimum, and maximum project duration?

**a) average**

```sql
SELECT
    ROUND(AVG(project_completion_date - project_start_date), 0) AS average_completion_time_days
FROM
    affordable_housing_production
WHERE
    project_completion_date IS NOT NULL
```

Results

| Metric                        | Value |
|-------------------------------|-------|
| Average Completion Time (days) | 480   |


**b) maximum**

```sql
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
```


Results

| Project ID | Project Duration (days) |
|------------|--------------------------|
| 58511      | 3016                     |

**c) minimum**

```sql
SELECT
    project_id,
    (project_completion_date - project_start_date) AS project_duration_days
FROM
    affordable_housing_production
WHERE
    project_completion_date IS NOT NULL
ORDER BY
    project_duration_days ASC
LIMIT 10;
```

Results

I am unsure about the interpretation of these results. I use limit 10 here so i can see the 10 projects with the smallest duration but i get negative or zero duration.

- ### Are certain construction types or boroughs associated with faster completions?

**a) boroughs**

```sql
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
```
Results

![Avg Completion Time by Borough](/Section%205%20-%20Trends%20Over%20Time/images/average_completion_time_by_borough.png)

*Bar chart of Avg Completion Time by Borough. This visualization was created with ChatGPT after importing my SQL query results*

- Brooklyn has the longest average project duration, which may indicate complex project requirements, larger projects, or delays in construction and approval processes.

- Manhattan is second after Brooklyn. This relatively high duration suggests that projects in Manhattan might also face complexities similar to Brooklyn's. 

- Staten Island, with the shortest duration, could reflect smaller-scale projects or a more streamlined construction and approval process.

- Queens and Bronx fall in between, suggesting moderate complexity or different efficiency levels in project management.

The variation in completion times could also reflect differences in local regulations, workforce availability, or funding structures across boroughs.

**b) construction types**

```sql
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
```

Results

| Reporting Construction Type | Average Completion Time (Days) |
|-----------------------------|-------------------------------|
| Preservation                | 544                           |
| New Construction            | 406                           |

The significant difference in timelines reflects the inherent complexities of preservation versus new construction. Preservation projects are more unpredictable and may require careful planning, while new construction benefits from starting with a blank slate. This can guide decision-making on project types based on timelines and priorities.


## 3. Annual Trends in Affordable Housing Production

- ### How has the production of affordable housing units changed over time?( What is the total number of affordable units produced by year?)

```sql
SELECT
    EXTRACT(YEAR FROM project_start_date) AS project_year, 
    SUM(all_counted_units) AS total_affordable_units
FROM
    affordable_housing_production
GROUP BY
    project_year
ORDER BY
    project_year;
```
Results

![Total Affordable Units by Year](/Section%205%20-%20Trends%20Over%20Time/images/total_affordable_units_by_year.png)

*Bar chart of Total Affordable Units by Year. This visualization was created with ChatGPT after importing my SQL query results*


- ###  What are the top 3 boroughs with the most affordable housing projects each year?

```sql
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
```

Results

| Borough      | 1st Place | 2nd Place | 3rd Place |
|--------------|-----------|-----------|-----------|
| Brooklyn     | 10        | 1         | 0         |
| Bronx        | 1         | 9         | 1         |
| Manhattan    | 0         | 1         | 6         |
| Queens       | 0         | 0         | 4         |


- ### How have the number of projects changed over time across all boroughs?

```sql
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
```

Here i start with a CTE which groups the data by borough and the year of the project start date. For each group, it calculates the total number of projects in that borough for that specific year by using EXTRACT(YEAR FROM project_start_date) to extract the year from the project start date and COUNT(*) to count the number of projects for each borough and year combination.

The main query then retrieves these yearly totals and uses the LAG() window function to compare the current year's project count with the previous year's count. The LAG() function allows us to "look back" at the previous row in the data partitioned by borough and ordered by year. This provides the number of projects from the previous year for the same borough. By subtracting the previous year's projects from the current year's, the query calculates the project difference, which shows whether the number of projects increased or decreased from one year to the next.

Finally, the results are ordered by borough and project_year to present the data in chronological order for each borough. This approach provides insights into the changes in the number of affordable housing projects across the boroughs over time, making it easier to track trends and identify significant increases or decreases in project activity.

- ### what is the cumulative number of projects by borough over time?

```sql
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
```

First i extract the year from the project_start_date and count the number of projects for each borough and each year, providing the total number of projects per borough annually. Then, i uses a window function to compute the cumulative number of projects up to each year for each borough, partitioning the data by borough and ordering it by year to ensure the cumulative sum is calculated correctly. By grouping the results by both borough and year, the query provides a detailed view of the project counts for each borough year by year. The final output is ordered by borough and year, showing the yearly project counts alongside the cumulative total, making it easy to track how the number of projects has evolved over time within each borough.
