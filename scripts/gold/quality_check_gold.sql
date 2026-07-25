-- =========================================================================
-- GOLD LAYER DATA QUALITY & INTEGRITY CHECKS
-- Goal: All queries below should return an 'issue_count' of 0.
-- =========================================================================

-- 1. Uniqueness Check: Ensure no duplicate surrogate keys in dim_customer
SELECT 
    'dim_customer: Duplicate customer_key' AS dq_check_name, 
    COUNT(*) AS issue_count
FROM (
    SELECT customer_key 
    FROM gold.dim_customer 
    GROUP BY customer_key 
    HAVING COUNT(*) > 1
) AS duplicates

UNION ALL

-- 2. Uniqueness Check: Ensure no duplicate surrogate keys in dim_product
SELECT 
    'dim_product: Duplicate product_key' AS dq_check_name, 
    COUNT(*) AS issue_count
FROM (
    SELECT product_key 
    FROM gold.dim_product 
    GROUP BY product_key 
    HAVING COUNT(*) > 1
) AS duplicates

UNION ALL

-- 3. Referential Integrity Check: Unmapped Customers in Fact Table
-- (Checks if a sales record has a customer_id that doesn't exist in dim_customer)
SELECT 
    'fact_sales: Unmapped customer_key (Failed JOIN)' AS dq_check_name, 
    COUNT(*) AS issue_count
FROM gold.fact_sales
WHERE customer_key IS NULL

UNION ALL

-- 4. Referential Integrity Check: Unmapped Products in Fact Table
-- (Checks if a sales record has a product_number not found in active dim_product)
SELECT 
    'fact_sales: Unmapped product_key (Failed JOIN)' AS dq_check_name, 
    COUNT(*) AS issue_count
FROM gold.fact_sales
WHERE product_key IS NULL

UNION ALL

-- 5. Completeness Check: Ensure no missing business keys in Fact Table
SELECT 
    'fact_sales: NULL order_number' AS dq_check_name, 
    COUNT(*) AS issue_count
FROM gold.fact_sales
WHERE order_number IS NULL

UNION ALL

-- 6. Logical Check: Negative or Zero Sales / Quantities (Optional Business Rule)
SELECT 
    'fact_sales: Invalid Sales Amount or Quantity (<= 0)' AS dq_check_name, 
    COUNT(*) AS issue_count
FROM gold.fact_sales
WHERE sales <= 0 OR quantity <= 0;
