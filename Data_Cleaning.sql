-- DATA CLEANING --
#######################

SELECT * 
FROM layoffs;

-- 1. Remove duplicates
-- 2. standardise the data
-- 3. Null values or blank values
-- 4. remove any columns

-- 1. REMOVE DUPLICATES
################################

-- so inorder to not loose any data from the raw table, we're going to 
-- stage the the raw data into a new table called layoffs_staging.

CREATE TABLE layoffs_staging
LIKE layoffs;


SELECT * 
FROM layoffs_staging;

-- Now we have created a table same as the raw table. 
-- Next we have add all the data in the raw table into the 
-- layoffs_staging table. 

INSERT INTO layoffs_staging
SELECT *
FROM layoffs;
-- So, the first thing we're going to do is removing the duplicates.
SELECT *,
ROW_NUMBER()
OVER(PARTITION BY company, location, industry,company,
 location, industry, total_laid_off, percentage_laid_off, `date`,
 stage, country, funds_raised_millions ) as row_num 
FROM layoffs_staging;

-- Here most of the looks unique, but there might be any value 2 for row_num
-- when we scroll down.

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER()
OVER(PARTITION BY company, location, industry,company,
 location, industry, total_laid_off, percentage_laid_off, `date`,
 stage, country, funds_raised_millions ) AS row_num 
FROM layoffs_staging 
)
SELECT *
FROM duplicate_cte
WHERE row_num >1;

-- Now we got the duplicates in the table and to confirm before removing
-- the duplicates, we can double check.

SELECT *
FROM layoffs_staging
WHERE company= 'cazoo';

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2;


INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry,company,
 location, industry, total_laid_off, percentage_laid_off, `date`,
 stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

SELECT *
FROM layoffs_staging2
where row_num > 1;

DELETE
FROM layoffs_staging2
where row_num > 1;

-- 2. STANDARDISE THE DATA
######################################

-- So first we are going to check  the first column of the layoffs_staging2
-- table, and removing the unwanted spaces in the company names.

SELECT * 
FROM layoffs_staging2
;

SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = (TRIM(company));

-- now we have cleaned the coloumn 'company'.
-- Next we're checking the next column, 'industry'.

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY industry;

SELECT industry
FROM layoffs_staging2
WHERE industry like 'crypto%';

UPDATE layoffs_staging2
SET industry = 'crypto'
WHERE industry like 'crypto%';

-- Next coloumn is location

SELECT DISTINCT location
FROM layoffs_staging2
ORDER BY location;

SELECT * 
FROM layoffs_staging2
;

-- Next is country

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

-- So we can see a duplicate of 'United States' with a '.' in the end.
-- We need to remove it

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country);

-- Next is column date

SELECT `date`
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- So here we are changing the format of the coloumn date and also changed
-- the data type to date. 

-- 3. NULL VALUES OR BLANK VALUES
##########################################
-- we had some null valuesin the industry column and we need to check those

SELECT industry 
FROM layoffs_staging2
WHERE industry is NULL OR industry = ''
;

-- So here we have four null values

SELECT * 
FROM layoffs_staging2
WHERE industry is NULL OR industry = ''
;

SELECT * 
from layoffs_staging2
where company = "Carvana";

-- From looking in the output we can see that 'carvana' company 
-- is in transportation industry. So like this we can simply fill the empty
-- cells. 

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry like '';

SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	 ON t1.company = t2.company
WHERE t1.industry IS NULL 
AND  t2.industry IS NOT NULL;
        
-- Now we have the values need to be copied. 

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company= t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL 
AND  t2.industry IS NOT NULL;

SELECT * 
FROM layoffs_staging2;

-- we don't need the data if there is null 
-- values in the  total_laid_off and percentage_laid_off

SELECT *
FROM layoffs_staging2
WHERE total_laid_off is NULL
AND percentage_laid_off IS NULL
;

DELETE 
FROM layoffs_staging2
WHERE total_laid_off is NULL
AND percentage_laid_off IS NULL
;
-- 4. REMOVE ANY COLUMN OR ROW
#################################
-- Now the last step we need to do is to remove the row_num column

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

SELECT * 
FROM layoffs_staging2;
