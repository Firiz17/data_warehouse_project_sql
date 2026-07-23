-->>LOAD
INSERT INTO silver.erp_loc_a101(cid,cntry)
SELECT
	TRIM(REPLACE(cid,'-','')) AS cid, -->> Remove the - from cid
	CASE WHEN cntry IN('DE','GERMANY') THEN 'Germany'
	 WHEN cntry IN('AU','AUSTRALIA') THEN 'Australia'
	 WHEN cntry IN('UK','UNITED KINGDOM') THEN 'United Kingdom'
	 WHEN cntry IN('USA','US','UNITED STATES') THEN 'United States'
	 WHEN cntry IN('CA','CANADA') THEN 'Canada'
	 WHEN cntry IN('FR','FRANCE') THEN 'France'
	ELSE 'n/a'
	END AS cntry
FROM bronze.erp_loc_a101;

-->>Check for abbreviation for standardization
SELECT DISTINCT
	cntry
FROM bronze.erp_loc_a101;
