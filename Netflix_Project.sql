--Netflix Project

CREATE TABLE netflix
(
	show_id	VARCHAR(6),
	type varchar (10),
	title varchar(150),
	director varchar (220),
	casts varchar (1000),	
	country	varchar (150),
	date_added varchar(50),
	release_year int,
	rating	varchar(15),
	duration varchar (15),
	listed_in	varchar(150),
	description varchar (350)

);




1. Count the number of Movies vs TV Shows


SELECT type , COUNT(*) as total_content
FROM netflix
GROUP BY type




2. Find the most common rating for movies and TV shows


WITH CTE as (
	SELECT type , rating , COUNT(*),
	RANK() OVER(PARTITION BY type  ORDER BY count(*) DESC) as ranking
	FROM netflix
	GROUP BY 1,2 )

	SELECT type , rating
	FROM cte
	WHERE ranking = 1




3. List all movies released in a specific year (e.g., 2020)


SELECT *
FROM netflix
WHERE type = 'Movie' AND release_year = 2020




4. Find the top 5 countries with the most content on Netflix


SELECT TRIM(UNNEST(STRING_TO_ARRAY(country, ','))) as new_country,
		COUNT(show_id) as content
FROM netflix
GROUP BY new_country
ORDER BY content desc
LIMIT 5




5. Identify the longest movie


SELECT title, MAX(CAST(SUBSTRING(duration,1,POSITION(' ' IN duration)-1)as INT)) as maximun_lenght
FROM netflix
WHERE type = 'Movie' AND duration IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1



6. Find content added in the last 5 years

SELECT * , TO_DATE(date_added, 'Month DD, YYYY') as date_add
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'




7. Find all the movies/TV shows by director 'Rajiv Chilaka'!


SELECT * 
FROM netflix
WHERE director LIKE '%Rajiv Chilaka%'




8. List all TV shows with more than 5 seasons


SELECT * , SPLIT_PART(duration , ' ' , 1) as season_number
FROM netflix
WHERE type = 'TV Show' AND SPLIT_PART(duration , ' ' , 1):: numeric > 5




9. Count the number of content items in each genre


SELECT 
	UNNEST(STRING_TO_ARRAY(listed_in, ','))as genre,
	COUNT(show_id) as totl_content
FROM netflix
GROUP by 1




10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!


SELECT 
	EXTRACT (Year FROM TO_DATE(date_added,'Month DD,YYYY')) as year,
	COUNT(*),
	ROUND(COUNT(*) ::numeric / (SELECT COUNT(*) FROM netflix WHERE country = 'India')::numeric * 100 , 2) as avg_content_per_year
FROM netflix
WHERE country = 'India'
GROUP BY 1
ORDER BY year




11. List all movies that are documentaries


SELECT *
FROM netflix
WHERE listed_in ILIKE '%documentaries%'




12. Find all content without a director


SELECT *
FROM netflix
WHERE director IS NULL




13. Find how many movies actor 'Salman Khan' appeared in last 10 years!


SELECT * 
FROM netflix
WHERE casts ILIKE '%salman khan%' AND release_year > EXTRACT(YEAR FROM CURRENT_DATE ) - 10




14. Find the top 10 actors who have appeared in the highest number of movies produced in India.


SELECT 
	UNNEST(STRING_TO_ARRAY(casts , ',')) as individual_actors,
	COUNT(*) as total_movies
FROM netflix
WHERE country ILIKE 'India'
GROUP BY UNNEST(STRING_TO_ARRAY(casts , ','))
ORDER BY total_movies desc
LIMIT 10




15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.


WITH cte as (
	SELECT * ,
 	CASE WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad_Content' ELSE 'Good_content' END as category
	FROM netflix )

	SELECT category , count(*) as total_content
	FROM cte 
	GROUP BY category
















