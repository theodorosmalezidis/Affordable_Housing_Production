# PROJECT OVERVIEW

## Project Statistics

- How many housing projects have been completed and how many were ongoing or have missing completion dates??

```sql
SELECT 
    COUNT(CASE WHEN project_completion_date IS NOT NULL THEN 1 END) AS completed_projects,
    COUNT(CASE WHEN project_completion_date IS NULL THEN 1 END) AS uncompleted_projects
FROM
    affordable_housing_production;
```



