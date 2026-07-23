--======================================================
--LOAD
INSERT INTO silver.crm_sales_details(
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price
)
SELECT
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	CASE WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
		ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE) --CAST cannot change interger
	END AS sls_order_dt,
	CASE WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
		ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE) --CAST cannot change interger
	END AS sls_ship_dt,
	CASE WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
		ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE) --CAST cannot change interger
	END AS sls_due_dt,
	CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity*ABS(sls_price)
	THEN sls_quantity*ABS(sls_price)
	ELSE sls_sales
	END AS sls_sales,
	sls_quantity,
	CASE WHEN sls_price <=0 OR sls_price IS NULL
	THEN sls_sales/ NULLIF(sls_quantity,0)
	ELSE sls_price
	END AS sls_price
FROM bronze.crm_sales_details
--======================================================
-->>Check for unwanted space
SELECT
	*
FROM bronze.crm_sales_details;

SELECT
	sls_prd_key
FROM bronze.crm_sales_details
WHERE sls_prd_key != TRIM(sls_prd_key);

-->>Check if the key is properly connected
SELECT
	sls_prd_key
FROM bronze.crm_sales_details
WHERE sls_prd_key NOT IN (SELECT prd_key FROM silver.crm_prd_info);
SELECT
	sls_cust_id
FROM bronze.crm_sales_details
WHERE sls_cust_id NOT IN (SELECT cst_id FROM silver.crm_cust_info);

-->>Check for invalid dates
--Need to convert the sls_order_dt from interger to Date but it has 0 in it
--Need to convert the 0 to NULL
--Check the total number in the column must be 8
--Check for outlier date

SELECT
	NULLIF(sls_order_dt,0) sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <=0 OR 
	  LEN(sls_order_dt) != 8 OR
	  sls_order_dt > 20500101 OR
	  sls_order_dt < 19000101;

-->>Check for invalid order dates
SELECT
	*
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
	  OR sls_order_dt > sls_due_dt

-->>Check data consistency: Between Sales, Quantity, and Price
-->> Sales = Quantity * Price
-->> Values must not be NULL or NEGATIVE or 0
SELECT DISTINCT
	sls_quantity,
	sls_price AS old_price,
	sls_sales AS old_sales,

	CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity*ABS(sls_price)
	THEN sls_quantity*ABS(sls_price)
	ELSE sls_sales
	END AS sls_sales,

	CASE WHEN sls_price <=0 OR sls_price IS NULL
	THEN sls_sales/ NULLIF(sls_quantity,0)
	ELSE sls_price
	END AS sls_price
FROM bronze.crm_sales_details
WHERE sls_price <=0 OR sls_quantity <=0 OR sls_sales <=0
	  OR sls_price IS NULL OR sls_quantity IS NULL OR sls_sales IS NULL
	  OR sls_sales != sls_price*sls_quantity
ORDER BY sls_sales,sls_quantity,sls_price;

-->>SOLUTION : The source system owner will fix it directly on the source OR fix it in the warehouse
--> If Sales is negative ,zero or NULL derive using Price and Quantity
-->If price is zero or NULL, calculate using Sales and Quantity
--> If price is negative, change it to positive
