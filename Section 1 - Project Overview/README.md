# PROJECT OVERVIEW

## 1. Project Statistics

- ### How many housing projects have been completed and how many were ongoing or have missing completion dates??

```sql
SELECT 
    COUNT(CASE WHEN project_completion_date IS NOT NULL THEN 1 END) AS completed_projects,
    COUNT(CASE WHEN project_completion_date IS NULL THEN 1 END) AS uncompleted_projects
FROM
    affordable_housing_production;
```

Results

![Project Completion Status](/Section%201%20-%20Project%20Overview/images/project_completion_status.png)

*Bar chart of Project Completion Status. This visualization was created with ChatGPT after importing my SQL query results*

Completed projects are more by far!

- ### What is the number of units per project?

```sql
SELECT
    project_id,
    SUM(all_counted_units) AS total_units_per_project
FROM
    affordable_housing_production
GROUP BY
    project_id
ORDER BY
    total_units_per_project DESC;
```


- ### What is the average number of units per project?

```sql
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
```

Results

| Average units per project |
|---------------------------|
|56,63                      |


- ### How many projects are associated with each project id?

```sql
SELECT
    project_id,
    COUNT(*) AS number_of_projects
FROM
    affordable_housing_production
GROUP BY
    project_id
ORDER BY
    number_of_projects DESC;
```


## 2. PROJECT DISTRIBUTION


- ### What is the distribution of projects across boroughs?

```sql
SELECT
    borough,
    COUNT(*) AS number_of_projects
FROM
    affordable_housing_production
GROUP BY
    borough
ORDER BY
    number_of_projects DESC;
```



Results
![completed_projects](/Section%201%20-%20Project%20Overview/images/number_of_projects_by_borough_chart.png)


*Bar chart for Number of Projects per Borough. This visualization was created with ChatGPT after importing my SQL query results*

This distribution of projects across boroughs can provide insights into several key aspects of housing policy and urban development:
- Geographic Priorities
- Economic Disparities
- Policy Objectives
- Infrastructure and Space Availability
- Community Needs
- Effectiveness of Housing Programs


- ### Which borough has the highest number of projects completed?

```sql
SELECT
    borough,
    COUNT(CASE WHEN project_completion_date IS NOT NULL THEN 1 END) AS completed_projects
FROM
    affordable_housing_production
GROUP BY
    borough
ORDER BY
    completed_projects DESC;
```


Results

![completed_projects](/Section%201%20-%20Project%20Overview/images/completed_projects_by_borough_graph.png)
*Bar chart for Completed Projects by Borough. This visualization was created with ChatGPT after importing my SQL query results*

The results follow the same pattern as the distribution of projects across boroughs.

## 3. CONSTRUCTION TYPES


- ### How many projects are categorized under each "Reporting Construction Type"? What is the most common construction type for affordable housing?

```sql
SELECT
    reporting_construction_type,
    COUNT(*)
FROM
    affordable_housing_production
GROUP BY
    reporting_construction_type;
```

Results

![construction_types](/Section%201%20-%20Project%20Overview/images/construction_type_bar_chart.png)
*Bar chart for Completed Projects by Borough. This visualization was created with ChatGPT after importing my SQL query results*

Pretty close, but the Preservation type edged ahead. This might indicate that the city is balancing its efforts between maintaining existing affordable housing (Preservation) and creating new affordable housing units (New Construction).
