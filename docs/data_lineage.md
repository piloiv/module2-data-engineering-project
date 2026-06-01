# Data Lineage

## Source To Raw

Each CSV file in `data/raw` is loaded into DuckDB under the `raw` schema. File names are converted into table names by removing the Olist prefix and dataset suffix.

| Source file | Raw table |
| --- | --- |
| `olist_customers_dataset.csv` | `raw.customers` |
| `olist_geolocation_dataset.csv` | `raw.geolocation` |
| `olist_order_items_dataset.csv` | `raw.order_items` |
| `olist_order_payments_dataset.csv` | `raw.order_payments` |
| `olist_order_reviews_dataset.csv` | `raw.order_reviews` |
| `olist_orders_dataset.csv` | `raw.orders` |
| `olist_products_dataset.csv` | `raw.products` |
| `olist_sellers_dataset.csv` | `raw.sellers` |
| `product_category_name_translation.csv` | `raw.product_category_name_translation` |

## Raw To Warehouse

| Warehouse table | Inputs | Transformation logic |
| --- | --- | --- |
| `warehouse.dim_customer` | `raw.customers` | Adds surrogate customer key and standardizes city/state text |
| `warehouse.dim_product` | `raw.products`, `raw.product_category_name_translation` | Adds surrogate product key and English category names |
| `warehouse.dim_seller` | `raw.sellers` | Adds surrogate seller key and standardizes city/state text |
| `warehouse.dim_date` | `raw.orders` | Builds reusable date rows from purchase, approval, delivered, and estimated delivery dates |
| `warehouse.fact_sales` | `raw.order_items`, `raw.orders`, `raw.order_payments`, `raw.order_reviews`, dimensions | Joins order item transactions to dimensions, payment aggregates, review aggregates, and derived delivery measures |

## Quality Gates

The warehouse is accepted only when all SQL checks in `sql/quality_checks` return zero failing rows. The checks cover:

- Required keys are not null
- Order item fact rows are unique
- Fact foreign keys resolve to dimensions
- Sales amounts are non-negative and internally consistent
- Review scores are within the expected 1 to 5 range
- Order status values match the known Olist lifecycle states
