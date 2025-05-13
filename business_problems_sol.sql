--Netflix Project

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

SELECT * FROM NETFLIX;


SELECT COUNT(*) AS total_content
from netflix;

select distinct type from netflix;

-- 15 Business Problems & Solutions

-- 1. Count the number of Movies vs TV Shows

select type,count(*) as total_count
	from netflix
group by type;

-- 2. Find the most common rating for movies and TV shows
select type, rating
from
	(select type,
	rating,
	count(*),
	rank() over(partition by type order by count(*) desc) as ranking
	 from netflix
	 group by type, rating) as t1
 where ranking =1;


-- 3. List all movies released in a specific year (e.g., 2020)

select * from netflix
where type = 'Movie'
and
release_year = 2020  ;

-- 4. Find the top 5 countries with the most content on Netflix

select 
	unnest(string_to_array(country,',')) as top_countries,
	count(show_id) as total_content
from netflix 
group by top_countries
order by total_content desc
limit 5;


-- 5. Identify the longest movie

SELECT 
	*
FROM netflix
WHERE type = 'Movie'
ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC

-- 6. Find content added in the last 5 years

select *
from netflix 
where to_date(date_added, 'Month DD, YYYY') >= current_date - interval '5years';

-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!


select *
from netflix
where director ilike '%Rajiv Chilaka%';



-- 8. List all TV shows with more than 5 seasons

select *
from netflix
where 
	type = 'TV Show'
	and 
	split_part(duration,' ',1) :: int  > 5;


-- 9. Count the number of content items in each genre

select
	unnest(string_to_array(listed_in,',')) as genre,
	count(*) as total_count
from netflix 
group by genre;

-- 10.Find each year and the average numbers of content release in India on netflix. 
-- return top 5 year with highest avg content release!

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

-- 11. List all movies that are documentaries

SELECT * FROM netflix
WHERE listed_in iLIKE '%Documentaries%';

select* from netflix;
-- 12. Find all content without a director

select * from netflix where director is null ;


-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
 
select * from netflix
where 
	casts ilike '%Salman Khan%'
and
	release_year > extract(year from current_date) - 10;

-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

select unnest(string_to_array(casts,',')) as actors,
   count(*) as total_no_movies
from netflix
where country ilike '%India%'
group by 1
order by total_no_movies desc
limit 10;


-- 15.
-- Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
-- the description field. Label content containing these keywords as 'Bad' and all other 
-- content as 'Good'. Count how many items fall into each category.


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





