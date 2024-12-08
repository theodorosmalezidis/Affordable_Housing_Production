# GEOSPATIAL ANALYSIS

## 1. Neighborhood Trends

- ### What are the top 10 neighborhoods (Neighborhood Tabulation Areas) with the most units and to which borough are they located?

```sql
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
```
Results

| NTA Neighborhood Tabulation Area | Borough   | NTA Total Units |
|----------------------------------|-----------|-----------------|
| BX1004                           | Bronx     | 15372           |
| BK0504                           | Brooklyn  | 8973            |
| MN1002                           | Manhattan | 7605            |
| MN1101                           | Manhattan | 7459            |
| BX0401                           | Bronx     | 6570            |
| QN1204                           | Queens    | 6168            |
| MN1102                           | Manhattan | 5719            |
| BX0101                           | Bronx     | 5035            |
| MN0601                           | Manhattan | 5000            |
| QN1401                           | Queens    | 4641            |


- ### What percentage of each borough's total housing units is provided by its Neighborhood Tabulation Areas (NTAs)?

```sql
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
```


In this query, two CTEs are used to calculate the percentage of total units in each Neighborhood Tabulation Area (NTA) relative to its corresponding borough. The first CTE  calculates the total number of units for each borough by summing the all_counted_units across all NTAs in the borough. The second CTE calculates the total number of units for each NTA within each borough. The final query joins these two CTEs on the borough field and then calculates the percentage of total units in each NTA by dividing the nta_total_units by the borough_total_units_sum and multiplying by 100. The results are ordered by borough and the percentage of units in descending order, providing insight into how each NTA contributes to its borough's total affordable housing units.

- This query offers several insights into housing distribution within boroughs:

    **Contribution Analysis:** It reveals how much each NTA contributes to the borough’s total housing stock, helping identify imbalances in resource allocation or concentration.

    **Identify Dominant NTAs:** It highlights NTAs with disproportionately high contributions, pointing to areas that may be over-concentrated or in need of focused development.

    **Policy Planning:** Policymakers can use this data to ensure fair distribution of housing and address underserved areas needing attention.

    **Prioritization of Resources:** Areas with low housing percentages can be targeted for future developments or investment to address gaps.

    **Comparison Across Boroughs:** It allows comparisons between boroughs, revealing those with more balanced or uneven housing distribution, aiding in the evaluation of housing policies.

In summary, the query helps assess housing equity, inform policy decisions, and prioritize areas requiring attention or investment.

- ### Which a)income types and b)bedroom categories do neighborhoods focus on, based on the percentage of housing units?"

**a) income types**

```sql
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
```


**b) bedroom categories**

```sql
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
```