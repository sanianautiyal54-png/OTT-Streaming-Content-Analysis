create database NetflixAnalysis


USE NetflixAnalysis;
GO


SELECT COUNT(*) AS total_titles
FROM dbo.netflix_titles;


SELECT TOP 10 *
FROM dbo.netflix_titles;


SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'netflix_titles';


-- Count titles by content type
SELECT type, COUNT(*) AS total_titles
FROM dbo.netflix_titles
GROUP BY type
ORDER BY total_titles DESC;


-- Count titles by the year they were added
SELECT
    YEAR(TRY_CONVERT(date, date_added)) AS year_added,
    COUNT(*) AS total_titles
FROM dbo.netflix_titles
WHERE TRY_CONVERT(date, date_added) IS NOT NULL
GROUP BY YEAR(TRY_CONVERT(date, date_added))
ORDER BY year_added;


-- Count each genre, splitting titles with multiple genres
SELECT TOP 10
    LTRIM(RTRIM(value)) AS genre,
    COUNT(*) AS total_titles
FROM dbo.netflix_titles
CROSS APPLY STRING_SPLIT(listed_in, ',')
WHERE listed_in IS NOT NULL
GROUP BY LTRIM(RTRIM(value))
ORDER BY total_titles DESC;


-- Count country appearances, including co-productions
SELECT TOP 10
    LTRIM(RTRIM(value)) AS country,
    COUNT(*) AS total_titles
FROM dbo.netflix_titles
CROSS APPLY STRING_SPLIT(country, ',')
WHERE country IS NOT NULL
  AND LTRIM(RTRIM(value)) <> ''
GROUP BY LTRIM(RTRIM(value))
ORDER BY total_titles DESC;


-- Find the most common content ratings
SELECT TOP 10
    rating,
    COUNT(*) AS total_titles
FROM dbo.netflix_titles
WHERE rating IS NOT NULL
GROUP BY rating
ORDER BY total_titles DESC;


-- Calculate average, minimum, and maximum movie duration
WITH MovieData AS (
    SELECT
        TRY_CONVERT(
            int,
            LEFT(duration, CHARINDEX(' ', duration + ' ') - 1)
        ) AS duration_minutes
    FROM dbo.netflix_titles
    WHERE type = 'Movie'
)
SELECT
    COUNT(duration_minutes) AS movies_analyzed,
    AVG(CAST(duration_minutes AS decimal(10,2))) AS average_minutes,
    MIN(duration_minutes) AS shortest_minutes,
    MAX(duration_minutes) AS longest_minutes
FROM MovieData;


-- Compare content types by original release year
SELECT
    release_year,
    type,
    COUNT(*) AS total_titles
FROM dbo.netflix_titles
WHERE release_year IS NOT NULL
GROUP BY release_year, type
ORDER BY release_year;


-- Find directors with the most titles
SELECT TOP 10
    LTRIM(RTRIM(value)) AS director,
    COUNT(*) AS total_titles
FROM dbo.netflix_titles
CROSS APPLY STRING_SPLIT(director, ',')
WHERE director IS NOT NULL
GROUP BY LTRIM(RTRIM(value))
ORDER BY total_titles DESC;


-- Compare ratings for movies and TV shows
SELECT
    type,
    rating,
    COUNT(*) AS total_titles
FROM dbo.netflix_titles
WHERE rating IS NOT NULL
GROUP BY type, rating
ORDER BY type, total_titles DESC;









