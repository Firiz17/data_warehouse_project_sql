/*
===================================
CREATE DATABASE AND SCHEMAS
===================================

Script purpose:
	This script creates a new database named 'DataWarehouse1' after checking it already exist.
	If the database exists, it is dropped and recreated. Additionally, the script set up 3 schemas
	within the database ,bronze,silver,gold.

WARNING!
	Running the script wil drop the entire existing database therefore please ensure
	that a backup has been made.
*/

USE Master;
GO

--Drop and recreate the DataWarehouse1 database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name='DataWarehouse1')
BEGIN
	ALTER DATABASE DataWarehouse1 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse1;
END;
GO

--create database
CREATE DATABASE DataWarehouse1;
GO

USE DataWarehouse1;
GO

--create schema
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
