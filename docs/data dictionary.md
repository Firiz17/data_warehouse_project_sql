# 🛒 Dataset: `gold.fact_sales`

**Layer:** `Gold` | **Type:** `Fact View` | **Domain:** `Sales / CRM`

## 📖 Description
The `gold.fact_sales` view is the central fact table for analyzing sales performance. It contains granular, transaction-level data for all sales orders, including pricing, quantities, and total sales amounts. 

This view is optimized for Business Intelligence (BI) and reporting, providing foreign keys (`product_key`, `customer_key`) that seamlessly link to the Gold presentation dimensions.

---

## 🏗️ Dependencies (Lineage)
This view joins cleansed transactional data from the Silver layer with surrogate keys from the Gold dimension tables.

| Source Object | Layer | Alias | Role | Join Condition |
| :--- | :--- | :--- | :--- | :--- |
| `silver.crm_sales_details` | Silver | `sd` | Base Table | N/A |
| `gold.dim_product` | Gold | `dp` | Dimension | `sd.sls_prd_key = dp.product_number` |
| `gold.dim_customer` | Gold | `dc` | Dimension | `sd.sls_cust_id = dc.customer_id` |

---

## 📊 Data Dictionary

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

## 💻 DDL / SQL Definition

<details>
<summary>Click to view the SQL query</summary>

```sql
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
