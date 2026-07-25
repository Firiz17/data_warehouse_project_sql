# 🛒 Data Dictionary for Gold Layer
---

## 📖 Overview
The `gold.fact_sales` view is the central fact table for analyzing sales performance. It contains granular, transaction-level data for all sales orders, including pricing, quantities, and total sales amounts. 

This view is optimized for Business Intelligence (BI) and reporting, providing foreign keys (`product_key`, `customer_key`) that seamlessly link to the Gold presentation dimensions.

---

### 1. gold.fact_sales

| Column Name | Data Type (Expected) | Source Column | Description |
| :--- | :--- | :--- | :--- |
| `order_number` | `VARCHAR` | `sd.sls_ord_num` | The unique, human-readable identifier for the sales order. |
| `product_key` | `INT / UUID` | `dp.product_key` | Surrogate foreign key linking to `gold.dim_product`. |
| `customer_key` | `INT / UUID` | `dc.customer_key` | Surrogate foreign key linking to `gold.dim_customer`. |
| `order_date` | `DATE` | `sd.sls_order_dt` | The date the customer placed the order. |
| `ship_date` | `DATE` | `sd.sls_ship_dt` | The date the order was shipped from the facility. |
| `due_date` | `DATE` | `sd.sls_due_dt` | The date the order is expected to be delivered or payment is due. |
| `price` | `DECIMAL` | `sd.sls_price` | The unit price of the product at the time of sale. |
| `quantity` | `INT` | `sd.sls_quantity` | The number of units purchased in this transaction line. |
| `sales` | `DECIMAL` | `sd.sls_sales` | Total monetary value of the transaction line (`price * quantity`). |

---

### 2. gold.dim_customer

**Description:** 
The `gold.dim_customer` view serves as the master dimension table for customer information. It consolidates demographic, geographic, and profile data from both CRM and ERP source systems into a single, clean view.

| Column Name | Data Type (Expected) | Source Column | Description |
| :--- | :--- | :--- | :--- |
| `customer_key` | `INT` | `ROW_NUMBER()` | Auto-generated surrogate primary key for the dimension table. |
| `customer_id` | `INT / VARCHAR` | `ci.cst_id` | The internal system identifier for the customer. |
| `customer_number` | `VARCHAR` | `ci.cst_key` | The natural business key associated with the customer. |
| `first_name` | `VARCHAR` | `ci.cst_firstname` | The customer's first name. |
| `last_name` | `VARCHAR` | `ci.cst_lastname` | The customer's last name. |
| `country` | `VARCHAR` | `cl.cntry` | The customer's country of residence (sourced from location data). |
| `marital_status` | `VARCHAR` | `ci.cst_marital_status` | The marital status of the customer. |
| `gender` | `VARCHAR` | `ci.cst_gndr` / `cb.gen` | The customer's gender, prioritized from CRM data, with ERP data as a fallback. |
| `birth_date` | `DATE` | `cb.bdate` | The customer's date of birth. |
| `creation_date` | `DATE` | `ci.cst_create_date` | The date the customer record was originally created. |

---

### 3. gold.dim_product

**Description:** 
The `gold.dim_product` view is the master dimension table for product details. It enriches basic CRM product information with hierarchical categorizations (category, sub-category) from the ERP system, filtering exclusively for currently active products (`prd_end_dt IS NULL`).

| Column Name | Data Type (Expected) | Source Column | Description |
| :--- | :--- | :--- | :--- |
| `product_key` | `INT` | `ROW_NUMBER()` | Auto-generated surrogate primary key for the dimension table. |
| `product_id` | `INT / VARCHAR` | `pn.prd_id` | The internal system identifier for the product. |
| `product_number` | `VARCHAR` | `pn.prd_key` | The natural business key or SKU for the product. |
| `product_name` | `VARCHAR` | `pn.prd_nm` | The full name or description of the product. |
| `product_line` | `VARCHAR` | `pn.prd_line` | The broader family, brand, or line the product belongs to. |
| `category_id` | `VARCHAR` | `pn.cat_id` | The system identifier mapping to the product's category. |
| `category` | `VARCHAR` | `pc.cat` | The primary categorization of the product. |
| `sub_category` | `VARCHAR` | `pc.subcat` | The secondary, more granular categorization of the product. |
| `maintenance` | `VARCHAR` | `pc.maintenance` | Maintenance indicators, service levels, or status for the product. |
| `cost` | `DECIMAL` | `pn.prd_cost` | The unit cost to manufacture or procure the product. |
| `start_date` | `DATE` | `pn.prd_start_dt` | The effective start date of the product's current lifecycle. |
