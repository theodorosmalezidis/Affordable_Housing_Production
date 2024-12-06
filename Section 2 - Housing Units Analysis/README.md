# HOUSING UNITS ANALYSIS

## 1. Income-Based Units

- ### What is the distribution of housing units by income type (e.g., Extremely Low Income, Low Income)?

```sql
SELECT
    SUM(extremely_low_income_units) AS extremely_low_income_units_total,
    SUM(very_low_income_units) AS very_low_income_units_total,
    SUM(low_income_units) AS low_income_units_total,
    SUM(moderate_income_units) AS moderate_income_units_total,
    SUM(middle_income_units) AS middle_income_units_total,
    SUM(other_income_units) AS other_income_units_total
FROM
    affordable_housing_production;
```

Results

| Income Category                | Total Units |
|--------------------------------|-------------|
| Extremely Low Income Units     | 45,461      |
| Very Low Income Units          | 74,413      |
| Low Income Units               | 91,999      |
| Moderate Income Units          | 16,337      |
| Middle Income Units            | 33,061      |
| Other Income Units             | 1,136       |

   
    


1. Low Income Units (91,999) make up the largest share, showing a strong focus on addressing affordability for this group.
2. Very Low Income Units (74,413) and Extremely Low Income Units (45,461) follow, indicating significant efforts to assist the most vulnerable populations.
3. Middle Income Units (33,061) and Moderate Income Units (16,337) represent smaller proportions, likely targeting more stable income brackets.
4. Other Income Units (1,136) make up a minimal share, suggesting they are a specialized or less emphasized category.

This distribution reflects a prioritization of low-income households in housing programs.

- ### And by percentage the share of each income type in the total housing units?

```sql
WITH Total_Units AS (
    SELECT
        SUM(extremely_low_income_units) AS extremely_low_income_units_total,
        SUM(very_low_income_units) AS very_low_income_units_total,
        SUM(low_income_units) AS low_income_units_total,
        SUM(moderate_income_units) AS moderate_income_units_total,
        SUM(middle_income_units) AS middle_income_units_total,
        SUM(other_income_units) AS other_income_units_total
    FROM
        affordable_housing_production
)
SELECT
    ROUND((extremely_low_income_units_total * 100.0) / (
        extremely_low_income_units_total +
        very_low_income_units_total +
        low_income_units_total +
        moderate_income_units_total +
        middle_income_units_total +
        other_income_units_total
    ), 2) AS extremely_low_income_percentage,
    ROUND((very_low_income_units_total * 100.0) / (
        extremely_low_income_units_total +
        very_low_income_units_total +
        low_income_units_total +
        moderate_income_units_total +
        middle_income_units_total +
        other_income_units_total
    ), 2) AS very_low_income_percentage,
    ROUND((low_income_units_total * 100.0) / (
        extremely_low_income_units_total +
        very_low_income_units_total +
        low_income_units_total +
        moderate_income_units_total +
        middle_income_units_total +
        other_income_units_total
    ), 2) AS low_income_percentage,
    ROUND((moderate_income_units_total * 100.0) / (
        extremely_low_income_units_total +
        very_low_income_units_total +
        low_income_units_total +
        moderate_income_units_total +
        middle_income_units_total +
        other_income_units_total
    ), 2) AS moderate_income_percentage,
    ROUND((middle_income_units_total * 100.0) / (
        extremely_low_income_units_total +
        very_low_income_units_total +
        low_income_units_total +
        moderate_income_units_total +
        middle_income_units_total +
        other_income_units_total
    ), 2) AS middle_income_percentage,
    ROUND((other_income_units_total * 100.0) / (
        extremely_low_income_units_total +
        very_low_income_units_total +
        low_income_units_total +
        moderate_income_units_total +
        middle_income_units_total +
        other_income_units_total
    ), 2) AS other_income_percentage
FROM Total_Units;
```
 I use a CTE named Total_Units to aggregate the total number of units for each income category using the SUM aggregation function. In the final query, i calculate the proportional contribution (as a percentage) of each income category to the overall total units across all categories (i know there is a more simple way without the cte but i thought it was more fun this way!).

Results
![Income type distibution](/Section%202%20-%20Housing%20Units%20Analysis/images/income_distribution_pie_chart.png)
*Pie chart of each income type in the total housing units. This visualization was created with ChatGPT after importing my SQL query results*

- ### Which borough provides the most units for each income group?

```sql
WITH IncomeGroupRanking AS (
    SELECT
        borough,
        SUM(extremely_low_income_units) AS extremely_low_income_units_total,
        SUM(very_low_income_units) AS very_low_income_units_total,
        SUM(low_income_units) AS low_income_units_total,
        SUM(moderate_income_units) AS moderate_income_units_total,
        SUM(middle_income_units) AS middle_income_units_total,
        SUM(other_income_units) AS other_income_units_total
    FROM
        affordable_housing_production
    GROUP BY
        borough
),
RankedBoroughs AS (
    SELECT
        borough,
        'Extremely Low Income' AS income_group,
        extremely_low_income_units_total AS units,
        ROW_NUMBER() OVER (ORDER BY extremely_low_income_units_total DESC) AS rank
    FROM IncomeGroupRanking
    UNION ALL
    SELECT
        borough,
        'Very Low Income' AS income_group,
        very_low_income_units_total AS units,
        ROW_NUMBER() OVER (ORDER BY very_low_income_units_total DESC)
    FROM IncomeGroupRanking
    UNION ALL
    SELECT
        borough,
        'Low Income' AS income_group,
        low_income_units_total AS units ,
        ROW_NUMBER() OVER (ORDER BY low_income_units_total DESC)
    FROM IncomeGroupRanking
    UNION ALL
    SELECT
        borough,
        'Moderate Income' AS income_group,
        moderate_income_units_total AS units,
        ROW_NUMBER() OVER (ORDER BY moderate_income_units_total DESC)
    FROM IncomeGroupRanking
    UNION ALL
    SELECT
        borough,
        'Middle Income' AS income_group,
        middle_income_units_total AS units,
        ROW_NUMBER() OVER (ORDER BY middle_income_units_total DESC)
    FROM IncomeGroupRanking
    UNION ALL
    SELECT
        borough,
        'Other Income' AS income_group,
        other_income_units_total AS units,
        ROW_NUMBER() OVER (ORDER BY other_income_units_total DESC)
    FROM IncomeGroupRanking
)
SELECT
    income_group,
    borough,
    units
FROM
    RankedBoroughs
WHERE
    rank = 1
```
This is a very tricky one, that is why is a good challenge. I use two ctes, in the first i aggregate the total units for each income group grouped by borough. In the second i use the UNION ALL operator to combine results for each income group, applying the ROW_NUMBER() window function to assign a rank to each borough based on total units in descending order. In the final query i select the income_group, borough, and units fields, showing which borough ranks highest in terms of total units for each income group.

Results
| Income Group            | Borough    | Units  |
|-------------------------|------------|--------|
| Extremely Low Income    | Bronx      | 15,494 |
| Very Low Income         | Bronx      | 28,468 |
| Low Income              | Bronx      | 33,010 |
| Moderate Income         | Manhattan  | 5,940  |
| Middle Income           | Brooklyn   | 10,044 |
| Other Income            | Bronx      | 491    |



Bronx Dominates Lower Income Categories:
The Bronx has the highest number of units in Extremely Low Income, Very Low Income, and Low Income categories, indicating that it likely has a larger focus or demand for affordable housing catering to individuals with lower income levels.

Moderate and Middle Income Categories Show Other Borough Leadership:
Manhattan leads in the Moderate Income category with 5,940 units, suggesting it may cater to those with moderate income levels, possibly due to its more urbanized environment and high living costs.
Brooklyn leads in the Middle Income category with 10,044 units, indicating a substantial presence of housing targeting middle-income individuals, possibly reflecting a mix of urban and residential development.

Other Income Category is Minor:
The Other Income category has a relatively small number of units, especially in the Bronx (491 units). This may represent a smaller portion of housing projects that don’t fit into the traditional income groups.

Overall, these results suggest that the Bronx is a major hub for lower-income housing, while other boroughs, like Manhattan and Brooklyn, focus more on moderate to middle-income groups.



- ### What are the top 5 projects by units for each borough?

```sql
WITH ranking_projects AS(
    SELECT
        borough,
        project_id,
        COUNT(all_counted_units) AS total_counted_units,
        ROW_NUMBER() OVER(PARTITION BY borough ORDER BY COUNT(all_counted_units) DESC) AS rank
    FROM
        affordable_housing_production
    GROUP BY
        borough,
        project_id
)
SELECT
    borough,
    project_id,
    rank,
    total_counted_units
FROM    
     ranking_projects
WHERE
    rank <=5
```

First i use a CTE to calculate the total number of all_counted_units for each project_id, grouped by both borough and project_id and a window function to assign a sequential rank to each project within its respective borough. The projects are ordered by the count of all_counted_units in descending order, ensuring that projects with the highest counts are ranked first. In the final query i select borough, project_id, rank, and total_counted_units to present the rankings and i filter the results, using the WHERE rank <= 5 condition, retrieving only the top 5 projects for each borough based on total counted units.


## 2. Bedroom Breakdown

- ### How many total units are available for each bedroom category?

```sql
SELECT
    SUM(studio_units) AS studio_sum,
    SUM(one_br_units) AS one_br_sum,
    SUM(two_br_units) AS two_br_sum,
    SUM(three_br_units) AS three_br_sum,
    SUM(four_br_units) AS four_br_sum,
    SUM(five_br_units) AS five_br_sum,
    SUM(six_br_plus_units) AS six_br_plus_sum,
    SUM(unknown_br_units) AS unknown_br_sum
FROM
    affordable_housing_production
```

Results

| Bedroom Type     | Total Units |
|------------------|-------------|
| Studio           | 43,478      |
| One Bedroom      | 94,924      |
| Two Bedroom      | 87,525      |
| Three Bedroom    | 30,283      |
| Four Bedroom     | 2,478       |
| Five Bedroom     | 134         |
| Six or More      | 87          |
| Unknown Bedroom  | 3,498       |

One and Two Bedroom Units are the most common, with 94,924 and 87,525 units, respectively, reflecting high demand for smaller living spaces.

Studio Units also have a significant presence, with 43,478 units.

Larger Units (Three, Four, Five, and Six Bedrooms) are less common, with Four Bedrooms having only 2,478 units and Five Bedrooms just 134.

Unknown Bedroom Units total 3,498, possibly indicating incomplete data.

Overall, smaller units dominate the housing stock, with larger units being far less prevalent.


- ### -- What is the total number of studio, 1-BR, 2-BR, etc., units per project?

```sql
SELECT 
    project_id, 
    SUM(studio_units) AS studio_total,
    SUM(one_br_units) AS one_br_total,
    SUM(two_br_units) AS two_br_total,
    SUM(three_br_units) AS three_br_total,
    SUM(four_br_units) AS four_br_total,
    SUM(five_br_units) AS five_br_total,
    SUM(six_br_plus_units) AS six_br_plus_total,
    SUM(unknown_br_units) AS unknown_br_total
FROM
    affordable_housing_production 
GROUP BY
    project_id
ORDER BY
    studio_total,
    one_br_total,
    two_br_total,
    three_br_total,
    four_br_total,
    five_br_total,
    six_br_plus_total,
    unknown_br_total;
```

A simple one. First i calculate the total number of units for each bedroom type (e.g., studio, one-bedroom, two-bedroom) for every project by using SUM() for aggregation and grouping the results by project_id.

- ### Which bedroom category has the highest number of units in each borough?


```sql

WITH BrUnitsRanking AS (
    SELECT
        borough,
        SUM(studio_units) AS studio_total,
        SUM(one_br_units) AS one_br_total,
        SUM(two_br_units) AS two_br_total,
        SUM(three_br_units) AS three_br_total,
        SUM(four_br_units) AS four_br_total,
        SUM(five_br_units) AS five_br_total,
        SUM(six_br_plus_units) AS six_br_plus_total,
        SUM(unknown_br_units) AS unknown_br_total
    FROM
        affordable_housing_production
    GROUP BY
        borough
),
RankedBoroughs AS (
    SELECT
        borough,
        'studio_units' AS br_group,
        studio_total AS units,
        ROW_NUMBER() OVER (ORDER BY studio_total DESC) AS rank
    FROM BrUnitsRanking
    UNION ALL
    SELECT
        borough,
        'one_br_units' AS br_group,
        one_br_total AS units,
        ROW_NUMBER() OVER (ORDER BY one_br_total DESC)
    FROM BrUnitsRanking
    UNION ALL
    SELECT
        borough,
        'two_br_units' AS br_group,
        two_br_total AS units ,
        ROW_NUMBER() OVER (ORDER BY two_br_total DESC)
    FROM BrUnitsRanking
    UNION ALL
    SELECT
        borough,
        'three_br_units' AS br_group,
        three_br_total AS units,
        ROW_NUMBER() OVER (ORDER BY three_br_total DESC)
    FROM BrUnitsRanking
    UNION ALL
    SELECT
        borough,
        'four_br_units' AS br_group,
        four_br_total AS units,
        ROW_NUMBER() OVER (ORDER BY four_br_total DESC)
    FROM BrUnitsRanking
    UNION ALL
    SELECT
        borough,
        'five_br_units' AS br_group,
        five_br_total AS units,
        ROW_NUMBER() OVER (ORDER BY five_br_total DESC)
    FROM BrUnitsRanking
    UNION ALL
    SELECT
        borough,
        'six_br_plus_units' AS br_group,
        six_br_plus_total AS units,
        ROW_NUMBER() OVER (ORDER BY six_br_plus_total DESC)
    FROM BrUnitsRanking
    UNION ALL
    SELECT
        borough,
        'unknown_br_units' AS br_group,
        unknown_br_total AS units,
        ROW_NUMBER() OVER (ORDER BY unknown_br_total DESC)
    FROM BrUnitsRanking 
)
SELECT
    br_group,
    borough,
    units
FROM
    RankedBoroughs
WHERE
    rank = 1;
```
First i used two CTE s before my final query. The first aggregates the total units for each bedroom type (studio, one-bedroom, etc.) by borough. The second CTE, RankedBoroughs, uses the UNION ALL operator to combine results for each bedroom type, applying the ROW_NUMBER() window function to assign a rank to each borough in descending order of total units for that type. In the final query, the WHERE rank = 1 condition filters the results to show only the borough with the highest unit count for each bedroom type, along with the corresponding unit totals.

Results

| Bedroom Group       | Borough   | Units  |
|---------------------|-----------|--------|
| Studio Units        | Bronx     | 14,460 |
| One Bedroom Units   | Bronx     | 30,612 |
| Two Bedroom Units   | Bronx     | 29,723 |
| Three Bedroom Units | Bronx     | 12,422 |
| Four Bedroom Units  | Brooklyn  | 899    |
| Five Bedroom Units  | Brooklyn  | 47     |
| Six+ Bedroom Units  | Manhattan | 60     |
| Unknown Bedroom     | Brooklyn  | 1,171  |


The Bronx leads in most bedroom categories, including studio, one-bedroom, two-bedroom, and three-bedroom units, reflecting its dominance in unit availability. Brooklyn ranks highest for four-bedroom, five-bedroom, and unknown bedroom units, while Manhattan leads in six-plus bedroom units, highlighting its specialization in larger accommodations.


## 3.Ownership and Rental Units

- ### How many rental and ownership units each borough has?(keep in mind there is some overlap here)

```sql
SELECT
    borough,
    SUM(counted_rental_units) AS counted_rental_units_total,
    SUM(counted_homeownership_units) AS counted_homeownership_units_total
FROM
    affordable_housing_production
GROUP BY
    borough;
```

Results

![Rental and Homeownership Units Distribution Across Boroughs](/Section%202%20-%20Housing%20Units%20Analysis/images/rental_and_%20homeownership_units_distribution_across_boroughs.png)

*Bar chart of Rental and Homeownership Units Distribution Across Boroughs. This visualization was created with ChatGPT after importing my SQL query results*


The Bronx has the highest number of both rental units (88,506) and homeownership units (22,337), reflecting its significant housing stock. Brooklyn follows with a high count of rental units (74,764) but fewer homeownership units (8,781). Manhattan also shows a strong presence in rental units (61,346) and a notable number of homeownership units (14,338). Queens has a moderate distribution of both rental (34,493) and homeownership units (11,378). Staten Island, by contrast, has the fewest units in both categories, highlighting its smaller scale of housing projects.

