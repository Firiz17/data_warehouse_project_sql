/* 
	Since this table have many new derived column and changed attribute,
	it need to be updated in the DDL
*/
--========================================================
INSERT INTO silver.crm_prd_info(
	prd_id,
	cat_id,
	prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
)
SELECT 
	prd_id,
	REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS cat_id, --extracting first 5 part of prd_key
	SUBSTRING(prd_key,7,LEN(prd_key)) AS prd_key,
	prd_nm,
	COALESCE(prd_cost,0) AS prd_cost,
	CASE UPPER(TRIM(prd_line)) 
		 WHEN 'M' THEN 'Mountain'
		 WHEN 'R' THEN 'Road'
		 WHEN 'S' THEN 'Other Sales'
		 WHEN 'T' THEN 'Touring'
		 ELSE 'n/a'
	END AS prd_line,
	CAST(prd_start_dt AS DATE) prd_start_dt,
	CAST(LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt ASC)-1 AS DATE) prd_end_dt
FROM bronze.crm_prd_info


SELECT * FROM bronze.erp_loc_a101
--============================
--Quality check
--============================
-->>Check for unwanted spaces in String values
--Expectation: no result
SELECT
	prd_nm
FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-->>Check for nulls or negative number
SELECT
	prd_cost
FROM bronze.crm_prd_info
WHERE prd_cost <0 OR prd_cost IS NULL;

-->>Check for standardization and consistency
SELECT DISTINCT
	prd_line
FROM bronze.crm_prd_info
--Then handle the abbreviation with case when

-->>Check for invalid date orders
SELECT
	prd_key,
	prd_nm,
	prd_cost,
	prd_start_dt,
	prd_end_dt
FROM bronze.crm_prd_info
WHERE prd_key IN ('AC-HE-HL-U509-R','AC-HE-HL-U509') 
--There are multiple ways to handle this so need to brainstorm
--Solution: Use LEAD function for the next Start Date as the previous End date
