# Data_Cleaning_Project

In this project, data cleaning in MySQL involves a structured approach to enhance data quality and reliability through four primary steps:

1. **Removing Duplicates**: Initially, we identify and eliminate duplicate records within the dataset. Since there isn't a unique identifier readily available, we employ a method where each row is assigned a unique row number. This process ensures that each entry is distinct and prevents redundancy in the analysis.

2. **Standardizing Data**: Standardization aims to normalize the format of the data for consistency and accuracy. This involves removing extraneous spaces or characters from columns, ensuring uniformity across the dataset. By eliminating inconsistencies, such as leading or trailing spaces in text fields, we enhance data integrity and facilitate easier querying and analysis.

3. **Handling Null and Blank Values**: Null and blank values can introduce errors and inaccuracies into the analysis. To address this, we systematically identify and remove rows containing null or empty values across relevant columns. Alternatively, depending on the context, we may replace null values with appropriate placeholders or default values to maintain data completeness and usability.

4. **Removing Unwanted Columns**: As part of optimizing the dataset, we identify and exclude columns that are irrelevant or redundant for the analysis objectives. This step involves carefully evaluating each column's relevance to the project's goals and removing those that do not contribute meaningful insights. By reducing the dataset to essential variables, we streamline data processing and improve the efficiency of subsequent analytical tasks.

Overall, these data cleaning steps in MySQL are essential for ensuring the accuracy, consistency, and completeness of our dataset. By adhering to these practices, we enhance the reliability of the data analysis and enable informed decision-making based on trustworthy information.


In this SQL script for data cleaning, we start by ensuring data preservation and preparation through several systematic steps.

Firstly, we create a staging table `layoffs_staging` identical to the original `layoffs` table to avoid data loss and maintain the integrity of raw data. This staging table serves as a workspace where all transformations will be applied.

Next, we insert all records from `layoffs` into `layoffs_staging` to begin processing. The initial focus is on identifying and addressing duplicates within the dataset. Using the `ROW_NUMBER()` function partitioned by various columns like `company`, `location`, `industry`, etc., we pinpoint duplicate entries by assigning row numbers and then querying for rows where `row_num > 1`.

To manage these duplicates effectively, we create a new table `layoffs_staging2` based on `layoffs_staging`, including a `row_num` column for duplicate identification. After inserting data into `layoffs_staging2`, we filter out duplicates using `row_num > 1` and delete them to ensure only unique records remain.

The cleaning process continues by addressing data inconsistencies such as trailing spaces in the `company` column, achieved through the `TRIM()` function and subsequent updates to cleanse the data. Similarly, industry classifications are standardized, for instance, consolidating variations like 'crypto-related' industries into a unified category 'crypto'.

Attention then turns to refining geographical data like `country`, where extraneous characters such as trailing periods are removed for consistency. The `date` column undergoes format conversion using `STR_TO_DATE()` to ensure uniformity and accuracy in date representation, followed by an alteration of the column data type to `DATE`.

Additionally, handling null values in the `industry` column involves identifying and updating missing values based on corresponding company information. Records with null values in critical fields like `total_laid_off` and `percentage_laid_off` are identified and subsequently removed to maintain data integrity.

Finally, unnecessary columns like `row_num` are dropped from `layoffs_staging2` after cleaning operations are complete, ensuring the final dataset is streamlined and optimized for analysis.

This comprehensive approach ensures that the data is thoroughly cleansed, standardized, and ready for insightful analysis, laying a robust foundation for extracting meaningful insights and supporting informed decision-making processes based on reliable data.
