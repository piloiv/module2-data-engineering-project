# Data Lineage

## Source To Raw

Each CSV file in `data/raw` is loaded into DuckDB under the `raw` schema. File names are converted into table names by removing the Olist prefix and dataset suffix.

| Source file | Raw table |
| --- | --- |
| `olist_customers_dataset.csv` | `raw.raw_customers` |
| `olist_geolocation_dataset.csv` | `raw.raw_geolocation` |
| `olist_order_items_dataset.csv` | `raw.raw_order_items` |
| `olist_order_payments_dataset.csv` | `raw.raw_order_payments` |
| `olist_order_reviews_dataset.csv` | `raw.raw_order_reviews` |
| `olist_orders_dataset.csv` | `raw.raw_orders` |
| `olist_products_dataset.csv` | `raw.raw_products` |
| `olist_sellers_dataset.csv` | `raw.raw_sellers` |
| `product_category_name_translation.csv` | `raw.raw_product_category_name_translation` |

## Raw To Warehouse

| Warehouse table | Inputs | Transformation logic |
| --- | --- | --- |
| `warehouse.dim_customer` | `raw.raw_customers` | Adds surrogate customer key and standardizes city/state text |
| `warehouse.dim_product` | `raw.raw_products`, `raw.raw_product_category_name_translation` | Adds surrogate product key and English category names |
| `warehouse.dim_seller` | `raw.raw_sellers` | Adds surrogate seller key and standardizes city/state text |
| `warehouse.dim_date` | `raw.raw_orders` | Builds reusable date rows from purchase, approval, delivered, and estimated delivery dates |
| `warehouse.fact_sales` | `raw.raw_order_items`, `raw.raw_orders`, `raw.raw_order_payments`, `raw.raw_order_reviews`, dimensions | Joins order item transactions to dimensions, order-level payment attributes, review aggregates, and derived delivery measures. `price` is Product GMV; `price + freight_value` is GTV. |
| `warehouse.fact_order_payment` | `raw.raw_order_payments` | Preserves order-level payment totals without multiplying values across order items |
| `warehouse.mart_platform_overview` | Warehouse facts and dimensions | Executive KPI snapshot for seller enablement |
| `warehouse.mart_seller_health` | Warehouse facts and dimensions | Seller action segmentation and retention proxies |
| `warehouse.mart_seller_concentration` | `warehouse.mart_seller_health` | Seller dependency risk by cumulative Product GMV share |
| `warehouse.mart_category_opportunity` | Warehouse facts and product dimension | Category demand and seller opportunity |
| `warehouse.mart_regional_fulfillment` | Warehouse facts, customer dimension, seller dimension | Regional delivery and fulfillment friction |

## Quality Gates

The warehouse is accepted only when all SQL checks in `sql/quality_checks` return zero failing rows. The checks cover:

- Required keys are not null
- Order item fact rows are unique
- Fact foreign keys resolve to dimensions
- Sales amounts are non-negative and internally consistent
- Review scores are within the expected 1 to 5 range
- Order status values match the known Olist lifecycle states
