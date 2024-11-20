# DATA CLEANINIG PROJECT  -

CREATE DATABASE WORLD_LAYOFFS;

CREATE TABLE layoffs
SELECT * FROM WORLD_LAYOFFS.csvjson;

SELECT * FROM WORLD_LAYOFFS.layoffs;
SELECT COUNT(*) FROM layoffs;

#----RAW DATA = csvjson
#----STAGING/DUPLICATE DATA = layoffs

# STEPS TO CLEAN THE DATA-
#STEP 1. REMOVE ANY DUPLICATES
#STEP 2. STANDARDIZE THE DATA
#STEP 3. NULL/BLANK VALUES
#STEP 4. REMOVE ANY UN-NECESSARY COLUMNS/ROWS


#STEP 1. - REMOVING THE DUPLICATES

SELECT * ,
	ROW_NUMBER()
    OVER(PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`, stage,country,funds_raised_millions) AS ROW_NUM
FROM WORLD_LAYOFFS.layoffs;
# ROW NUMBER REMAINS SAME WHEN THE VALUES ARE UNIQUE AND REPEATS ITSELF WHEN THE VALUES ARE SAME.

WITH DUPLICATE_CTE AS 
(
	SELECT * ,
		ROW_NUMBER()
		OVER(PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) AS ROW_NUM
	FROM WORLD_LAYOFFS.layoffs
)
SELECT * FROM DUPLICATE_CTE WHERE ROW_NUM > 1; 


SELECT * FROM WORLD_LAYOFFS.layoffs WHERE company = 'Casper'; 
SELECT * FROM WORLD_LAYOFFS.layoffs WHERE company = 'Cazoo';
SELECT * FROM WORLD_LAYOFFS.layoffs WHERE company = 'Hibob';
SELECT * FROM WORLD_LAYOFFS.layoffs WHERE company = 'Wildlife Studios';
SELECT * FROM WORLD_LAYOFFS.layoffs WHERE company = 'Yahoo';
 # ALL OF THESE COMPANIES HAVE 2 SAME ROWS AND THEREFORE ONE OF THEM SHOULD BE DELETED TO AVIOD DUPLICACY.
 

CREATE TABLE `layoffs2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` text,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` text,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci; 


SELECT * FROM layoffs2;


INSERT INTO layoffs2
SELECT * ,
	ROW_NUMBER()
    OVER(PARTITION BY company,industry,location,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) AS ROW_NUM
FROM WORLD_LAYOFFS.layoffs;

SELECT * FROM WORLD_LAYOFFS.layoffs2
WHERE row_num >1 ;

DELETE FROM WORLD_LAYOFFS.layoffs2
WHERE row_num > 1;

SELECT * FROM layoffs2;


# STEP 2. STANDARDIZING THE DATA-
-- 1. removing and updating gaps before & after the name of companies.

SELECT company FROM WORLD_LAYOFFS.layoffs2;

SELECT DISTINCT(TRIM(company))
FROM WORLD_LAYOFFS.layoffs2;

SELECT company, TRIM(company)
FROM layoffs2;

UPDATE layoffs2
SET company = TRIM(company);

SELECT * FROM layoffs2; 

-- 2. updating names of industries with slight changes in their names.

SELECT DISTINCT industry FROM WORLD_LAYOFFS.layoffs2 ORDER BY 1;

SELECT * FROM WORLD_LAYOFFS.layoffs2 WHERE industry LIKE 'Crypto%';

UPDATE WORLD_LAYOFFS.layoffs2 SET industry = 'Crypto' WHERE industry LIKE 'Crypto%'; 

SELECT DISTINCT industry FROM WORLD_LAYOFFS.layoffs2;

SELECT * FROM WORLD_LAYOFFS.layoffs2 WHERE industry LIKE 'Fin%';

UPDATE WORLD_LAYOFFS.layoffs2 SET industry = 'Finance' WHERE industry LIKE 'Fin%';

-- 3. updating location & country names to correct them.

SELECT DISTINCT location FROM WORLD_LAYOFFS.layoffs2 ORDER BY 1;

SELECT DISTINCT country FROM WORLD_LAYOFFS.layoffs2 ORDER BY 1;

SELECT * FROM WORLD_LAYOFFS.layoffs2 WHERE country LIKE 'United States%';

UPDATE WORLD_LAYOFFS.layoffs2 SET country = 'United States of America' WHERE country LIKE 'United States%';


# ANOTHER METHOD TO DO THIS-
				(SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
                FROM layoffs2 ORDER BY 1); 

SELECT DISTINCT country FROM layoffs2 ORDER BY 1;

SELECT `date` FROM layoffs2;

SELECT `date`, STR_TO_DATE(`date`,'%m/%d/%Y') FROM WORLD_LAYOFFS.layoffs2;

UPDATE WORLD_LAYOFFS.layoffs2 SET `date` = STR_TO_DATE(`date`,'%m/%d/%Y') WHERE `date` REGEXP('^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$'); 
 
SELECT * FROM WORLD_LAYOFFS.layoffs2;



# STEP 3. REMOVING ANY NULL/BLANK VALUES-
																	
SELECT DISTINCT industry FROM layoffs2;

UPDATE layoffs2 SET industry = NULL WHERE industry = '';  

SELECT *  FROM layoffs2 WHERE industry IS NULL OR industry = ''; 

SELECT * FROM layoffs2 WHERE company = 'Airbnb';

SELECT T1.industry,T2.industry
	FROM layoffs2 AS T1 
	JOIN layoffs2 AS T2 
	ON T1.company = T2.company 
WHERE T1.industry IS NULL 
  AND T2.industry IS NOT NULL;
  
UPDATE layoffs2 AS T1
JOIN layoffs2 AS T2
	ON T1.company = T2.company 
SET T1.industry = T2.industry 
WHERE T1.industry IS  NULL
AND T2.industry IS NOT NULL;


# STEP 4. REMOVING ANY UN-NECESSARY ROWS/COLUMNS-

SELECT * 
FROM WORLD_LAYOFFS.layoffs2 
WHERE (total_laid_off IS NULL OR total_laid_off = '' OR total_laid_off = 'NULL')
AND (percentage_laid_off IS NULL OR percentage_laid_off = '' OR percentage_laid_off = 'NULL')
LIMIT 10000;

DELETE 
FROM WORLD_LAYOFFS.layoffs2 
WHERE 
	(total_laid_off IS NULL OR total_laid_off = '' OR total_laid_off = 'NULL')
AND
	(percentage_laid_off IS NULL OR percentage_laid_off = '' OR percentage_laid_off = 'NULL')
LIMIT 100000;


SELECT * FROM WORLD_LAYOFFS.layoffs2;

ALTER TABLE WORLD_LAYOFFS.layoffs2
DROP COLUMN row_num;
  
# END





