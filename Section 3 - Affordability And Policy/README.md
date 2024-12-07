# AFFORDABILITY AND POLICY IMPACT

## 1. Extended Affordability

- ### How many projects are listed under "Extended Affordability Only"?

```sql
SELECT
    COUNT(CASE
            WHEN extended_affordability_only='Yes' THEN 1 END ) AS extended_affordabillity_only_projects
FROM
    affordable_housing_production;
```

Results

| Category                        | Count |
|---------------------------------|-------|
| Extended Affordability Only     | 1,095 |


So 1,095 projects out of a total of 7,637 projects are under this category, it indicates that a relatively small proportion (approximately 14%) of housing projects focus on extending affordability. This suggests that while the broader housing production strategy prioritizes creating new units or preserving existing affordability, extending affordability agreements is less common, potentially due to funding, policy priorities, or the challenges of renegotiating agreements for existing properties.

- ### Are these projects concentrated in specific boroughs ?

```sql
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
```
![Extended Affordability Projects](/Section%203%20-%20Affordability%20And%20Policy/images/extended_affordability_projects_by_borough.png)

*Bar chart of Extended Affordability Projects Across Boroughs. This visualization was created with ChatGPT after importing my SQL query results*

- ### How Extended Affordability correlates with the Reporting Construction Type?

```sql
SELECT
    reporting_construction_type,
    COUNT(*) AS total_projects,
    (COUNT(CASE WHEN extended_affordability_only='Yes' THEN 1 END)) * 100/ COUNT(*) AS extended_affordability_only_perc,
    (COUNT(CASE WHEN extended_affordability_only='No' THEN 1 END)) * 100/ COUNT(*) AS non_extended_affordability_only_perc
FROM
    affordable_housing_production
GROUP BY
    reporting_construction_type;
```

Results

| Reporting Construction Type | Total Projects | Extended Affordability Only (%) | Non-Extended Affordability Only (%) |
|-----------------------------|----------------|----------------------------------|-------------------------------------|
| Preservation                | 3,946          | 27                               | 72                                  |
| New Construction            | 3,691          | 0                                | 99                                  |


The data reveals that the majority of projects under "Preservation" (27%) have extended affordability, while most of the "New Construction" projects (99%) do not include extended affordability. This suggests that "Preservation" projects are more likely to offer extended affordability, whereas new constructions predominantly do not.


## 2. Prevailing Wage Impact

- ### How many projects follow "Prevailing Wage Status" ?

```sql
SELECT
    COUNT(*) AS total_projects,
    COUNT(CASE WHEN prevailing_wage_status = 'Prevailing Wage' THEN 1 END) AS prevailing_wage_projects
FROM
    affordable_housing_production;
```

Results

| Total Projects | Prevailing Wage Projects |
|----------------|--------------------------|
| 7,637          | 124                      |

In summary, the fact that only 124 out of 7,637 projects fall under the "Prevailing Wage" category suggests that most projects are not subject to these higher wage standards, which could affect the overall labor quality and cost dynamics in the affordable housing sector.

- ### Are certain income categories more prevalent in prevailing wage projects? ( wage requirements affect targeting of income levels?)

```sql
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
```

Results

![Prevailing Wage Distribution](/Section%203%20-%20Affordability%20And%20Policy/images/prevailing_wage_income_distribution.png)

*Pie chart of Prevailing Wage Projects per Income Categories Distribution. This visualization was created with ChatGPT after importing my SQL query results*