/* 
=======================================================
STORED PROCEDURE: Load bronze layer (source -> Bronze)
=======================================================
Script purpose:
  This stored procedure loads data into the bronze schema from external CSV files.
  It performs the following actions:
  - Truncate the bronze tables before loading data.
  - Uses the 'BULK INSERT' command to load data from CSV files to bronze tables.
Usage examples: EXEC bronze.load_bronze;
---------------------------------------------------------
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS 
BEGIN
	BEGIN TRY
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
		PRINT'============================================';
		PRINT 'Loading CRM Tables';
		PRINT'============================================';


		--Make sure the table is empty before inserting data
		PRINT'--------------------------------------------';
		PRINT '>>Truncating :bronze.crm_cust_info';
	
		TRUNCATE TABLE bronze.crm_cust_info;
		SET @batch_start_time = GETDATE();
		PRINT '>>Inserting data :bronze.crm_cust_info';
		SET @start_time = GETDATE();
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\Hariz\Desktop\PROJECT\sql-dwh-project-main\sql-data-warehouse-project-main\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR =',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>>Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time)AS NVARCHAR)+ ' seconds';
		--check the data quality
		--SELECT * FROM bronze.crm_cust_info;
		--check if all rows is inserted
		--SELECT COUNT(*) FROM bronze.crm_cust_info;
		--====================================================

		PRINT'--------------------------------------------';
		PRINT '>>Truncating :bronze.crm_prd_info';
	
		TRUNCATE TABLE bronze.crm_prd_info;
		SET @start_time = GETDATE();
		PRINT '>>Inserting data :bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\Hariz\Desktop\PROJECT\sql-dwh-project-main\sql-data-warehouse-project-main\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR =',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>>Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time)AS NVARCHAR)+ ' seconds';
		
		--SELECT * FROM bronze.crm_prd_info;
		--SELECT COUNT(*) FROM bronze.crm_prd_info;
		--=====================================================

		PRINT'--------------------------------------------';
		PRINT '>>Truncating :bronze.crm_sales_details';
	
		TRUNCATE TABLE bronze.crm_sales_details;
		SET @start_time = GETDATE();
		PRINT '>>Inserting data :bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\Hariz\Desktop\PROJECT\sql-dwh-project-main\sql-data-warehouse-project-main\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR =',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>>Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time)AS NVARCHAR)+ ' seconds';
		--SELECT * FROM bronze.crm_sales_details;
		--SELECT COUNT(*) FROM bronze.crm_sales_details;
		--=====================================================

		PRINT'============================================';
		PRINT 'Loading ERP Tables';
		PRINT'============================================';


		PRINT'--------------------------------------------';
		PRINT '>>Truncating :bronze.erp_cust_az12';
	
		TRUNCATE TABLE bronze.erp_cust_az12;
		SET @start_time = GETDATE();
		PRINT '>>Inserting data :bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\Hariz\Desktop\PROJECT\sql-dwh-project-main\sql-data-warehouse-project-main\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR =',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>>Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time)AS NVARCHAR)+ ' seconds';
		--SELECT * FROM bronze.erp_cust_az12;
		--SELECT COUNT(*) FROM bronze.erp_cust_az12;
		--=====================================================

		PRINT'--------------------------------------------';
		PRINT '>>Truncating :bronze.erp_loc_a101';
	
		TRUNCATE TABLE bronze.erp_loc_a101;
		SET @start_time = GETDATE();
		PRINT '>>Inserting data :bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\Hariz\Desktop\PROJECT\sql-dwh-project-main\sql-data-warehouse-project-main\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR =',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>>Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time)AS NVARCHAR)+ ' seconds';
		--SELECT * FROM bronze.erp_loc_a101;
		--SELECT COUNT(*) FROM bronze.erp_loc_a101;
		--=====================================================

		PRINT'--------------------------------------------';
		PRINT '>>Truncating :bronze.erp_px_cat_g1v2';
	
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
		SET @start_time = GETDATE();
		PRINT '>>Inserting data :bronze.erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\Hariz\Desktop\PROJECT\sql-dwh-project-main\sql-data-warehouse-project-main\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR =',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>>Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time)AS NVARCHAR)+ ' seconds';

		SET @batch_end_time= GETDATE();
		PRINT '>>Duration for the batch: ' + CAST(DATEDIFF(second,@batch_start_time,@batch_end_time)AS NVARCHAR)+ ' seconds';
		--SELECT * FROM bronze.erp_px_cat_g1v2;
		--SELECT COUNT(*) FROM bronze.erp_px_cat_g1v2;
	END TRY
	BEGIN CATCH
	PRINT '===========================================';
	PRINT 'ERROR OCCURED DURING BRONZE LAYER LOADING';
	PRINT '===========================================';
	END CATCH	
END
