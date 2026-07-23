--====================================================
--Check for Nulls or Duplicates in Primary Key
--Expected result: no Nulls or Duplicates
SELECT * FROM bronze.crm_cust_info;
SELECT 
	cst_id,
	COUNT(*)
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) >1 OR cst_id IS NULL;

--In this case we will pick the latest creation date since 
--that is the most recent information of the customer.
SELECT * FROM
(
	SELECT 
		*,
		ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) flag
	FROM bronze.crm_cust_info
)t WHERE flag!=1;
--====================================================
--Quality check :Check for unwanted spaces in String values
--Expectation: no result
SELECT
	--cst_key,
	cst_firstname
	--cst_lastname,
	--cst_marital_status,
	--cst_gndr
FROM bronze.crm_cust_info
WHERE TRIM(cst_firstname) !=cst_firstname;
--====================================================
--Data standardization & consistency
--Make the abbreviation more read-friendly
--Use case when
SELECT DISTINCT cst_marital_status
FROM bronze.crm_cust_info;

--====================================================

--Overall cleaning and Insert into
INSERT INTO silver.crm_cust_info(
	cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_marital_status,
	cst_gndr,
	cst_create_date
)
SELECT 
	cst_id,
	cst_key,
	TRIM(cst_firstname) AS cst_firstname, --trim unwanted space
	TRIM(cst_lastname) AS cst_lastname,
	CASE --Normalize status to make sure it is in readable format
		WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
		WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
		ELSE 'n/a'
	END cst_marital_status,
	CASE --Normalize status to make sure it is in readable format
		WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
		WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
		ELSE 'n/a'
	END cst_gndr,
	cst_create_date
FROM
( --to ensure there is no duplicate in the primary key
	SELECT 
		*,
		ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) flag
	FROM bronze.crm_cust_info
	WHERE cst_id IS NOT NULL
)t WHERE flag =1;
