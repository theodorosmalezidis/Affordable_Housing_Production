# Introduction

A real-life data exploration project is one I’ve been eager to undertake. This one focuses on the Affordable Housing Production by Building dataset, which offers detailed insights into affordable housing projects across New York City’s boroughs. The dataset includes information on housing units, construction types, and affordability levels, making it a rich resource for analysis.

The goal of this structured analysis, divided into five key sections, is to provide a comprehensive understanding of affordable housing initiatives in New York City. By analyzing trends, spatial patterns, and policy impacts, this project aims to uncover meaningful insights about housing efforts in the city.


# Dataset

The dataset is sourced from the [NYC OpenData](https://data.cityofnewyork.us/Housing-Development/Affordable-Housing-Production-by-Building/hg8x-zxpr/about_data) and and is maintained by The Department of Housing Preservation and Development (HPD) reports on projects, buildings, and units that began after January 1, 2014, and are counted towards either the Housing New York plan (1/1/2014 – 12/31/2021) or the Housing Our Neighbors: A Blueprint for Housing & Homelessness plan (1/1/2022 – present).


# My Tools for the Project

- **PostgreSQL :** A powerful, open-source relational database management system.
- **VS Code :** A lightweight, versatile code editor.
- **SQL :** Structured Query Language, a standardized programming language used to interact with relational databases.
- **Git :** A distributed version control system that tracks changes to files and facilitates collaboration among developers. .
- **GitHub :** Essential for sharing my SQL scripts and analysis, ensuring collaboration and project tracking.
- **ChatGPT :** A powerful tool for data visualization that helps me generate visual charts after providing the results of my queries.


# Exploration and Analysis

I structured this project into five sections to systematically cover specific areas I wanted to explore and analyze in detail.  By dividing the work into these sections, I was able to delve deeper into the data, uncover trends, and generate meaningful insights. This structured approach allows for a clear understanding of the dataset's content and context.

Please fell free to check out every section below by clicking on the links .


- [Section 1 - Project Overview](https://github.com/theodorosmalezidis/Affordable_Housing_Production/tree/main/Section%201%20-%20Project%20Overview)

- [Section 2 - Housing Units Analysis](https://github.com/theodorosmalezidis/Affordable_Housing_Production/tree/main/Section%202%20-%20Housing%20Units%20Analysis)

- [Section 3 - Affordability And Policy](https://github.com/theodorosmalezidis/Affordable_Housing_Production/tree/main/Section%203%20-%20Affordability%20And%20Policy)

- [Section 4 - Geospatial Analysis](https://github.com/theodorosmalezidis/Affordable_Housing_Production/tree/main/Section%204%20-%20Geospatial%20Analysis)

- [Section 5 - Trends Over Time](https://github.com/theodorosmalezidis/Affordable_Housing_Production/tree/main/Section%205%20-%20Trends%20Over%20Time)



----------------------------------------------------------------

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
