Create database Movies
USE Movies 
GO

--Retrieve information from the tables 
SELECT * FROM [2000-2009_cleanmovies]
SELECT * FROM [2010-2023_cleanmovies]
SELECT * FROM [2024_cleanmovies]

--Change data types of "year" column into date in all the tables 
ALTER TABLE [2000-2009_cleanmovies]
ADD DateYear Date

--Copying and transforming the data from the old column 
--to the new one
UPDATE [2000-2009_cleanmovies]
SET DateYear = CAST(CAST([year] AS NVARCHAR(4)) + '-01-01' AS DATE);	

--Check if the data is added to the new column
SELECT * FROM [2000-2009_cleanmovies]

--Drop year column
ALTER TABLE [2000-2009_cleanmovies]
DROP COLUMN [year]

--create another column 
ALTER TABLE [2000-2009_cleanmovies]
 ADD years SMALLINT

 --update to only year
 UPDATE [2000-2009_cleanmovies]
 SET years = YEAR(DateYear)

 --Rename it back to "year"
 EXEC sp_rename '2000-2009_cleanmovies.years', 'year', 'COLUMN';


 --Drop "DateYear" column
 ALTER TABLE [2000-2009_cleanmovies]
 DROP COLUMN DateYear

 --Drop "Domestic_percent" column
 ALTER TABLE [2000-2009_cleanmovies] 
 DROP COLUMN Domestic_percent

 --Drop "Foreign_percent" column
 ALTER TABLE [2000-2009_cleanmovies] 
 DROP COLUMN Foreign_percent

 
 --Retrieve information from "2010-2023_cleanmovies" table
 SELECT * FROM [2010-2023_cleanmovies]

 --Drop "Domestic_percent" column
 ALTER TABLE [2010-2023_cleanmovies] 
 DROP COLUMN Domestic_percent

 --Drop "Foreign_percent" column
 ALTER TABLE [2010-2023_cleanmovies] 
 DROP COLUMN Foreign_percent


 --Retrieve information from "2024_cleanmovies" table
 SELECT * FROM [2024_cleanmovies]

  --Drop "Domestic_percent" column
ALTER TABLE [2024_cleanmovies]
 DROP COLUMN Domestic_percent

 --Drop "Foreign_percent" column
ALTER TABLE [2024_cleanmovies]
 DROP COLUMN Foreign_percent


 --EXPLORATORY DATA ANALYSIS

--Retrieve the total sum of revenue generated for each year from 2000 to 2009
WITH CTE AS(
SELECT [Year], SUM(Worldwide) AS Total_Worldwide, 
	SUM(Domestic) AS Total_Domestic, SUM([Foreign]) AS Total_Foreign
	FROM [2000-2009_cleanmovies] 
	GROUP BY [year] 
  )
SELECT * FROM CTE
ORDER BY [year]

--Retrieve the highest revenue generated movies worldwide for each year from 2000-2009
SELECT [year], Release_Group, Worldwide, Highest_Revenue_Rank
FROM (SELECT [year], Release_Group, Worldwide, 
	ROW_NUMBER() OVER(PARTITION BY [year] ORDER BY Worldwide DESC) AS Highest_Revenue_Rank
	FROM [2000-2009_cleanmovies] 
	) AS Subquery 
WHERE Highest_Revenue_Rank = 1 
GROUP BY [year], Release_Group, Worldwide, Highest_Revenue_Rank


--Retrieve top 5 movies for each year from 2000-2009
WITH CTE AS(
	SELECT [Year], Release_Group, Worldwide, Domestic, [Foreign]
	FROM [2000-2009_cleanmovies] 
 ),
Top_Revenues AS (
	SELECT [Year], Release_Group, Worldwide, Domestic, [Foreign],
	ROW_NUMBER() OVER(PARTITION BY [Year] ORDER BY Worldwide DESC) AS Movies_Rank
	FROM CTE
) 
SELECT * FROM Top_Revenues 
WHERE Movies_Rank <= 5


--Retrieve the lowest revenue generated movies worldwide for each year from 2000 to 2009
SELECT [year], Release_Group, Worldwide, Lowest_Revenue_Rank 
FROM (SELECT [year], Release_Group, Worldwide, 
	ROW_NUMBER() OVER(PARTITION BY [year] ORDER BY Worldwide ASC) AS Lowest_Revenue_Rank
	FROM [2000-2009_cleanmovies] 
	) AS Subquery 
WHERE Lowest_Revenue_Rank = 1 
GROUP BY [year], Release_Group, Worldwide, Lowest_Revenue_Rank


--Retrieve movies whose Worldwde and foreign revenues are the same
SELECT Release_Group, Worldwide, [Foreign]
FROM [2000-2009_cleanmovies]  
WHERE Worldwide = [Foreign] AND Domestic = 0

--Retrieve movies in each year whose domestic revenues are zero from 2000 to 2009
WITH CTE AS(
	SELECT Release_Group, Domestic, [year], 
	ROW_NUMBER() OVER(PARTITION BY [year] ORDER BY [year]) AS Year_Rank
	FROM  [2000-2009_cleanmovies] 
	WHERE Domestic = 0
) 
SELECT * FROM CTE 


--Retrieve the total sum of revenue generated for each year from 2010 to 2023
WITH CTE AS (
SELECT [Year], SUM(Worldwide) AS Total_Worldwide, 
	SUM(Domestic) AS Total_Domestic, SUM([Foreign]) AS Total_Foreign
	FROM [2010-2023_cleanmovies] 
	GROUP BY [year] 
 )
SELECT * FROM CTE
ORDER BY [year]

--Retrieve the highest revenue generated movies worldwide for each year from 2010 to 2023
SELECT [year], Release_Group, Worldwide, Highest_Revenue_Rank
FROM (SELECT [year], Release_Group, Worldwide, 
	ROW_NUMBER() OVER(PARTITION BY [year] ORDER BY Worldwide DESC) AS Highest_Revenue_Rank
	FROM [2010-2023_cleanmovies] 
	) AS Subquery 
WHERE Highest_Revenue_Rank = 1 
GROUP BY [year], Release_Group, Worldwide, Highest_Revenue_Rank


--Retrieve top 5 movies for each year from 2010-2023
WITH CTE AS (
	SELECT [Year], Release_Group, Worldwide, Domestic, [Foreign],
	ROW_NUMBER() OVER(PARTITION BY [Year] ORDER BY Worldwide DESC) AS Movies_Rank
	FROM [2010-2023_cleanmovies]
) 
SELECT * FROM CTE
WHERE Movies_Rank <= 5


--Retrieve the lowest revenue generated movies worldwide for each year from 2010 to 2023
WITH CTE AS (
	SELECT [year], Release_Group, Worldwide,  
		ROW_NUMBER() OVER(PARTITION BY [year] ORDER BY Worldwide ASC) AS Lowest_Revenue_Rank
	FROM [2010-2023_cleanmovies] 
)
SELECT * FROM CTE 
WHERE Lowest_Revenue_Rank = 1

--Retrieve movies whose Worldwde and foreign revenues are the same from 2010 to 2023
SELECT Release_Group, Worldwide, [Foreign]
FROM  [2010-2023_cleanmovies]  
WHERE Worldwide = [Foreign] AND Domestic = 0

--Retrieve movies in each year whose domestic revenues are zero from 2010 to 2023
WITH CTE AS(
	SELECT Release_Group, Domestic, [year], 
	ROW_NUMBER() OVER(PARTITION BY [year] ORDER BY [year]) AS Year_Rank
	FROM  [2010-2023_cleanmovies] 
	WHERE Domestic = 0
)
SELECT * FROM CTE


--Retrieve the total sum of revenue for 2024
WITH CTE AS (
SELECT [Year], SUM(Worldwide) AS Total_Worldwide, 
	SUM(Domestic) AS Total_Domestic, SUM([Foreign]) AS Total_Foreign
	FROM [2024_cleanmovies] 
	GROUP BY [year] 
 )
SELECT * FROM CTE
ORDER BY [year]


--Retrieve the movie with the highest worldwide revenue for 2024.
SELECT [year], Release_Group, Worldwide, Highest_Revenue_Rank
FROM (SELECT [year], Release_Group, Worldwide, 
	ROW_NUMBER() OVER(PARTITION BY [year] ORDER BY Worldwide DESC) AS Highest_Revenue_Rank
	FROM [2024_cleanmovies] 
	) AS Subquery 
WHERE Highest_Revenue_Rank = 1 
GROUP BY [year], Release_Group, Worldwide, Highest_Revenue_Rank


--Retrieve the top 5 movies released in 2024 
WITH CTE AS (
	SELECT [Year], Release_Group, Worldwide, Domestic, [Foreign],
	ROW_NUMBER() OVER(PARTITION BY [Year] ORDER BY Worldwide DESC) AS Movies_Rank
	FROM [2024_cleanmovies]
) 
SELECT * FROM CTE
WHERE Movies_Rank <= 5


--Retrieve the lowest revenue generated movie for 2024
WITH CTE AS (
	SELECT [year], Release_Group, Worldwide,  
		ROW_NUMBER() OVER(PARTITION BY [year] ORDER BY Worldwide ASC) AS Lowest_Revenue_Rank
	FROM [2024_cleanmovies] 
)
SELECT * FROM CTE 
WHERE Lowest_Revenue_Rank = 1

--Retrieve movies whose Worldwde and foreign revenues are the same in 2024
SELECT Release_Group, Worldwide, [Foreign]
FROM  [2024_cleanmovies] 
WHERE Worldwide = [Foreign] AND Domestic = 0

--Retrieve movies in 2024 whose domestic revenues are zero 
WITH CTE AS(
	SELECT Release_Group, Domestic, [year], 
	ROW_NUMBER() OVER(PARTITION BY [year] ORDER BY [year]) AS Year_Rank
	FROM   [2024_cleanmovies] 
	WHERE Domestic = 0
)
SELECT * FROM CTE

										