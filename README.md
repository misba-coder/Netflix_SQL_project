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
- **Source:** [Kaggle Netflix Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)
  
## Tools & Technologies Used
- **Database:** PostgreSQL
- **Language:** SQL
- **Platform:** pgAdmin4

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
## Business Problems and Solutions

### 1.Count the Number of Movies vs TV Shows
```sql
select type,count(*) as total_count
	from netflix
group by type;
```
**Objective**: Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows
```sql

select type, rating
from
	(select type,
	rating,
	count(*),
	rank() over(partition by type order by count(*) desc) as ranking
	 from netflix
	 group by type, rating) as t1
 where ranking =1;
```
**Objective**: Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)
```sql
select * from netflix
where type = 'Movie'
and
release_year = 2020  ;
```
**Objective**: Retrieve all movies released in a specific year.

### 4. Find the Top 5 Countries with the Most Content on Netflix
```sql
select 
	unnest(string_to_array(country,',')) as top_countries,
	count(show_id) as total_content
from netflix 
group by top_countries
order by total_content desc
limit 5;
```
**Objective**: Identify the top 5 countries with the highest number of content items.

### 5. Identify the Longest Movie
```sql
SELECT 
	*
FROM netflix
WHERE type = 'Movie'
ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC
```
**Objective**: Find the movie with the longest duration.

### 6. Find Content Added in the Last 5 Years
```sql
select *
from netflix 
where to_date(date_added, 'Month DD, YYYY') >= current_date - interval '5years';
```
**Objective**: Retrieve content added to Netflix in the last 5 years.

### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'
```sql
select *
from netflix
where director ilike '%Rajiv Chilaka%';
```
**Objective**: List all content directed by 'Rajiv Chilaka'.

### 8. List All TV Shows with More Than 5 Seasons
```sql
select *
from netflix
where 
	type = 'TV Show'
	and 
	split_part(duration,' ',1) :: int  > 5;
```
**Objective**: Identify TV shows with more than 5 seasons.

### 9. Count the Number of Content Items in Each Genre
```sql
select
	unnest(string_to_array(listed_in,',')) as genre,
	count(*) as total_count
from netflix 
group by genre;
```
**Objective**: Count the number of content items in each genre.

### 10.Find each year and the average numbers of content release in India on netflix.Return top 5 year with highest avg content release
```sql
select
	extract(year from to_date(date_added, 'Month DD, YYYY')) as year,
	count(*) as yearly_content,
	round(count(*) :: numeric /(select count(*) from netflix
	where country = 'India'):: numeric *100,2) as avg_release_per_year
from netflix
where country = 'India'
group by 1
order by avg_release_per_year desc
limit 5;
```
**Objective**: Calculate and rank years by the average number of content releases by India.

### 11. List All Movies that are Documentaries
```sql
SELECT * FROM netflix
WHERE listed_in iLIKE '%Documentaries%';

select* from netflix;

```
**Objective**: Retrieve all movies classified as documentaries.

### 12. Find All Content Without a Director
```sql
select * from netflix where director is null ;
```
**Objective**: List content that does not have a director.

### 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
```sql
select * from netflix
where 
	casts ilike '%Salman Khan%'
and
	release_year > extract(year from current_date) - 10;
```
**Objective**: Count the number of movies featuring 'Salman Khan' in the last 10 years.

### 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
```sql
select unnest(string_to_array(casts,',')) as actors,
   count(*) as total_no_movies
from netflix
where country ilike '%India%'
group by 1
order by total_no_movies desc
limit 10;
```
**Objective**: Identify the top 10 actors with the most appearances in Indian-produced movies.

### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
```sql

with categorized_content as (
    SELECT 
		*,
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) 
SELECT 
    category,
    COUNT(*) AS content_count
	from categorized_content
GROUP BY 1;
```
**Objective**: Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## 📈 Key Insights from the Analysis

- 📽️ Netflix’s catalog has **more movies than TV shows**, emphasizing single-sitting content.
- 📅 The release of new titles significantly increased post-2015, peaking around 2019–2020.
- 🌍 **USA, India, and UK** are the leading countries in content production.
- 🎭 **Dramas, Comedies, and Documentaries** are the most dominant genres.
- 🎬 Certain directors are featured multiple times, indicating long-standing collaborations.
- 🗓️ Most titles were **added in 2019 and 2020**, reflecting Netflix’s aggressive content push.
- 🔞 Ratings are skewed toward **mature and general audiences**, serving a broad demographic.
- ⏱️ Several movies exceed **150 minutes**, possibly representing epic films or documentaries.


 ## Conclusion
 
- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.
This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.

## Author:
**[Misba Khatoon]**
**SQL Developer in Progress | Data Enthusiast**

📧 Email: [misbakhatoon910@gmail.com]  
🔗 LinkedIn: [Your LinkedIn]  


## 📜 License

This project is for educational and portfolio use only. Dataset © Netflix via Kaggle.



