# EXPLORATORY DATA ANALYSIS PROJECT 

SELECT * FROM WORLD_LAYOFFS.layoffs2;

-- 1. Maximum total_laid_off & percentage_laid_off.

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM WORLD_LAYOFFS.layoffs2;

-- 2. Minimum total_laid_off & percentage_laid_off.

SELECT MIN(total_laid_off),MIN(percentage_laid_off)
FROM layoffs2;

-- 3. Average total_laid_off & percentage_laid_off.

SELECT AVG(total_laid_off),AVG(percentage_laid_off)
FROM layoffs2;

-- 4. Count total_laid_off & percentage_laid_off.

SELECT COUNT(total_laid_off),COUNT(percentage_laid_off)
FROM layoffs2;

-- 5. Ordered by company.

SELECT * FROM WORLD_LAYOFFS.layoffs2 WHERE percentage_laid_off = 1 ORDER BY company;

-- 6. Ordered by total_laid_off.
SELECT * FROM layoffs2 WHERE percentage_laid_off = 1 ORDER BY total_laid_off;

-- 7. Ordered by funds_raised_millions.

SELECT * FROM layoffs2 WHERE percentage_laid_off = 1 ORDER BY funds_raised_millions;

SELECT * FROM layoffs2;

-- 8. company & sum of total_laid_off in order. 

SELECT company, SUM(total_laid_off)
FROM WORLD_LAYOFFS.layoffs2 
GROUP BY company 
ORDER BY 2 DESC;                                         #HERE 2 STANDS FOR THE POSITION VALUE OF COLUMNS. i.e. 1 = COLUMN 1, 2 = COLUMN 2

-- 9. Minimum & Maximum date.

SELECT MIN(`date`), MAX(`date`)
FROM layoffs2 ;

-- 10. industry & sum of total_laid_off in order.

SELECT industry, SUM(total_laid_off)
FROM WORLD_LAYOFFS.layoffs2 
GROUP BY industry
ORDER BY 2 DESC;

-- 11. country & sum of total_laid_off in order.

SELECT country, SUM(total_laid_off)
FROM WORLD_LAYOFFS.layoffs2 
GROUP BY country
ORDER BY 2 DESC;

-- 12. location & sum of total_laid_off in order.

SELECT location, SUM(total_laid_off)
FROM WORLD_LAYOFFS.layoffs2 
GROUP BY location
ORDER BY 2 DESC;

-- 13. stage  & sum of total_laid_off in order.

SELECT stage, SUM(total_laid_off)
FROM WORLD_LAYOFFS.layoffs2 
GROUP BY stage
ORDER BY 2 DESC;

-- 14. year & sum of total_laid_off in order.

SELECT YEAR(`date`), SUM(total_laid_off)
FROM WORLD_LAYOFFS.layoffs2 
GROUP BY YEAR(`date`)
ORDER BY 2 DESC;

-- 15. company & sum of percentage_laid_off in order.

SELECT company, SUM(percentage_laid_off)
FROM WORLD_LAYOFFS.layoffs2 
GROUP BY company
ORDER BY 2 DESC;

-- 16. company & average of percentage_laid_off in order.

SELECT company, AVG(percentage_laid_off)
FROM WORLD_LAYOFFS.layoffs2 
GROUP BY company
ORDER BY 2 DESC;

-- 17. date as month & sum of total_laid_off in order.

SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off)
FROM WORLD_LAYOFFS.layoffs2  
GROUP BY `MONTH`
ORDER BY 1 ASC;

-- 18. company & sum of total_laid_off in order.

SELECT company, SUM(total_laid_off)
FROM WORLD_LAYOFFS.layoffs2 
GROUP BY company
ORDER BY 2 DESC; 

-- 19. company , year & sum of total_laid_off in order.

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM WORLD_LAYOFFS.layoffs2 
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

-- 20. ranking based on sum of total_laid_off in order. 

WITH COMPANY_YEAR (Company, Years, Laid_off)  AS
(
	SELECT company, YEAR(`date`), SUM(total_laid_off)
    FROM WORLD_LAYOFFS.layoffs2 GROUP BY company, YEAR(`date`)
)
SELECT *, DENSE_RANK() OVER(PARTITION BY Years ORDER BY Laid_off DESC ) AS RANKING
FROM COMPANY_YEAR
WHERE Years IS NOT NULL
ORDER BY RANKING;

-- 21. ranks with equal or less than 5 based on sum of total_laid_off in order.

WITH COMPANY_YEARS1 (Company, Years, Laid_off) AS
(
	SELECT company, YEAR(`date`), SUM(total_laid_off)
    FROM WORLD_LAYOFFS.layoffs2 GROUP BY company, YEAR(`date`)
), COMPANY_YEARS2 AS
(
	SELECT *, DENSE_RANK() OVER(PARTITION BY Years ORDER BY laid_off DESC) AS RANKING
    FROM COMPANY_YEARS1
    WHERE Years IS NOT NULL
)
SELECT * FROM COMPANY_YEARS2
WHERE RANKING <=5 ;

# END - 




















