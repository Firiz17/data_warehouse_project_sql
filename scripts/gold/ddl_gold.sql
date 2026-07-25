/*
================================================================================
  DDL script : Create Gold Views
================================================================================

  Script purpose:
    This script creates views for the gold layer in the Data Warehouse.
    The gold layer represenets the final dimension and fact table (Star Schema)
================================================================================

*/
-->> Create dimension dim_customer
IF OBJECT_ID('gold.dim_customer') IS NOT NULL
    DROP VIEW gold.dim_customer;
GO

CREATE VIEW gold.dim_customer AS
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
GO

-->> Create dimension dim_product
IF OBJECT_ID('gold.dim_product') IS NOT NULL
    DROP VIEW gold.dim_product;
GO

CREATE VIEW gold.dim_product AS
SELECT 
	ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt,pn.prd_key) AS product_key, --creating the primary key
	pn.prd_id AS product_id,
	pn.prd_key AS product_number,
	pn.prd_nm AS product_name,
	pn.prd_line AS product_line,
	pn.cat_id AS category_id,
	pc.cat AS category,
	pc.subcat AS sub_category,
	pc.maintenance AS maintenance,
	pn.prd_cost AS cost,
	pn.prd_start_dt AS start_date
FROM silver.crm_prd_info AS pn
LEFT JOIN silver.erp_px_cat_g1v2 AS pc
ON pn.cat_id = pc.id
WHERE prd_end_dt IS NULL;
GO

-->> Create fact table fact_sales
IF OBJECT_ID('gold.fact_sales') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO

CREATE VIEW gold.fact_sales AS
SELECT
	sd.sls_ord_num AS order_number,
	dp.product_key,
	dc.customer_key,
	sd.sls_order_dt AS order_date,
	sd.sls_ship_dt AS ship_date,
	sd.sls_due_dt AS due_date,
	sd.sls_price AS price,
	sd.sls_quantity AS quantity,
	sd.sls_sales AS sales
FROM silver.crm_sales_details AS sd
LEFT JOIN gold.dim_product AS dp
ON sd.sls_prd_key = dp.product_number
LEFT JOIN gold.dim_customer AS dc
ON sd.sls_cust_id = dc.customer_id;
GO
