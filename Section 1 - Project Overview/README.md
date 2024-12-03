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



![Project Completion Status](/Section%201%20-%20Project%20Overview/images/project_completion_status.png)

*Bar chart of Project Completion Status. This visualization was created with ChatGPT after importing my SQL query results*
