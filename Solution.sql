## 1. DROP TABLE IF EXISTS
```sql
drop table if exists netflix;
```

## 2. CREATE TABLE
```sql
create table netflix (
    show_id varchar(6),
    type varchar(10),
    title varchar(150),
    director varchar(210),
    casts varchar(1000),
    country varchar(150),
    date_added varchar(50),
    release_year int,
    rating varchar(10),
    duration varchar(15),
    listed_in varchar(150),
    description varchar(250)
);
```

## 3. RETRIEVE ALL RECORDS
```sql
select * from netflix;
```

## 4. COUNT TOTAL NUMBER OF CONTENT
```sql
select count(*) as total_content from netflix;
```

## 5. RETRIEVE DISTINCT TYPES OF CONTENT
```sql
select distinct type from netflix;
```

## 6. COUNT TOTAL CONTENT FOR EACH TYPE
```sql
select type, count(*) as total_content from netflix group by type;
```

## 7. FIND THE MOST COMMON RATING FOR EACH TYPE
```sql
select type, rating
from (
    select type, rating, count(*),
           rank() over (partition by type order by count(*) desc) as ranking
    from netflix
    group by type, rating
) as t1
where ranking = 1;
```

## 8. RETRIEVE ALL MOVIES RELEASED IN 2020
```sql
select * from netflix
where type = 'Movie' and release_year = 2020;
```

## 9. FIND THE TOP 5 COUNTRIES WITH THE MOST CONTENT
```sql
select unnest(string_to_array(country, ',')) as new_country,
       count(show_id) as total_content
from netflix
group by new_country
order by total_content desc
limit 5;
```
## 10. Identify the Longest Movie
```sql
SELECT 
    *
FROM netflix
WHERE type = 'Movie'
ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC;
```

## 11. Find Content Added in the Last 5 Years
```sql
SELECT *
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';
```
## 12. Find All Movies/TV Shows by Director 'Rajiv Chilaka'
```sql
SELECT *
FROM (
    SELECT 
        *,
        UNNEST(STRING_TO_ARRAY(director, ',')) AS director_name
    FROM netflix
) AS t
WHERE director_name = 'Rajiv Chilaka';
```

## 13. List All TV Shows with More Than 5 Seasons
```sql
SELECT *
FROM netflix
WHERE type = 'TV Show'
  AND SPLIT_PART(duration, ' ', 1)::INT > 5;
```

## 14. Count the Number of Content Items in Each Genre
```sql
SELECT 
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
    COUNT(*) AS total_content
FROM netflix
GROUP BY 1;
```

## 15. Find each year and the average numbers of content release in India on netflix.
```sql
return top 5 year with highest avg content release!

SELECT 
    country,
    release_year,
    COUNT(show_id) AS total_release,
    ROUND(
        COUNT(show_id)::numeric /
        (SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100, 2
    ) AS avg_release
FROM netflix
WHERE country = 'India'
GROUP BY country, release_year
ORDER BY avg_release DESC
LIMIT 5;
```

## 16. List All Movies that are Documentaries
```sql
SELECT * 
FROM netflix
WHERE listed_in LIKE '%Documentaries';
```

## 17. Find All Content Without a Director
```sql
SELECT * 
FROM netflix
WHERE director IS NULL;
```

## 18. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
```sql
SELECT * 
FROM netflix
WHERE casts LIKE '%Salman Khan%'
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;
```

## 19. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
```sql
SELECT 
    UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
    COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY actor
ORDER BY COUNT(*) DESC
LIMIT 10;
```

## 20. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
```sql
SELECT 
    category,
    COUNT(*) AS content_count
FROM (
    SELECT 
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY category;
```
