# Netflix Content Analysis Using SQL 
![Netflix_logo](https://github.com/misba-coder/Netflix_SQL_project/blob/main/logo.png)
##  Overview
This project presents a comprehensive analysis of Netflix's movies and TV shows dataset using SQL. The primary objective is to extract meaningful insights and answer key business questions related to content distribution, trends, and audience preferences. This README outlines the project goals, analytical approach, SQL-based solutions, key findings, and conclusions drawn from the data.

## Objective
- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.
## Dataset
- Source: [Kaggle Netflix Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

##  Schema
```sql
CREATE TABLE netflix(
	show_id VARCHAR(6),
	type  VARCHAR(10),
	title  VARCHAR(150),
	director  VARCHAR(208),
	casts    VARCHAR(1000),
	country     VARCHAR(150),
	date_added   VARCHAR(50),
	release_year INT,
	rating      VARCHAR(10),
	duration   VARCHAR(15),
	listed_in  VARCHAR(100),
	description  VARCHAR(250)
);







```
