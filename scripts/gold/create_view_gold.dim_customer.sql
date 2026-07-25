--Generate surrogate key for the primary key
--can either define in DDL or do the Window Function
CREATE VIEW	gold.dim_customer AS
SELECT
	ROW_NUMBER() OVER (ORDER BY ci.cst_id) AS customer_key,
	ci.cst_id AS customer_id,
	ci.cst_key AS customer_number,
	ci.cst_firstname AS first_name,
	ci.cst_lastname AS last_name,
	cl.cntry AS country,
	ci.cst_marital_status AS marital_status,
	CASE
		WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr --If the data from CRM is other than na,then choose that
		ELSE COALESCE(cb.gen,'n/a')
	END AS gender,
	cb.bdate AS birth_date,
	ci.cst_create_date AS creation_date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 cb
ON ci.cst_key = cb.cid
LEFT JOIN silver.erp_loc_a101 cl
ON ci.cst_key = cl.cid;

--Check how to aggregate
--When the gender is different from crm and erp
--Consult with source system handler, ask which one is the master data
SELECT DISTINCT
	ci.cst_gndr,
	cb.gen,
	CASE
		WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr --If the data from CRM is other than na,then choose that
		ELSE COALESCE(cb.gen,'n/a')
	END AS new_gen
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 cb
ON ci.cst_key = cb.cid
LEFT JOIN silver.erp_loc_a101 cl
ON ci.cst_key = cl.cid
ORDER BY 1,2

