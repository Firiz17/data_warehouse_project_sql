-->>LOAD!
INSERT INTO silver.erp_cust_az12(cid,bdate,gen)

SELECT
	CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4,LEN(cid))-->>The cid has 3 extra characters so need to remove it
	ELSE cid
	END AS cid,
	CASE WHEN bdate <'1924-01-01' OR bdate>GETDATE() THEN NULL
	ELSE bdate
	END AS bdate,
	CASE 
		WHEN UPPER(TRIM(gen)) IN('F','FEMALE') THEN 'Female'
		WHEN UPPER(TRIM(gen)) IN('M','MALE') THEN 'Male'
		ELSE 'n/a' 
	END AS gen
FROM bronze.erp_cust_az12;


-->>Check date for old customers or some time traveler
SELECT DISTINCT
	bdate
FROM silver.erp_cust_az12
WHERE bdate <'1924-01-01' OR bdate>GETDATE(); 

-->>Check for gen abbreviation and standardize it
SELECT DISTINCT
	gen
FROM silver.erp_cust_az12
