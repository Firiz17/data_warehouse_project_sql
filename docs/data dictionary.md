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

