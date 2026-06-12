# Modernized Pipeline

## Purpose

The project now uses dbt for transformation, Streamlit for dashboarding, and Dagster for orchestration. The business lens remains Olist as a seller enablement platform: marketplace transactions are used to understand seller growth, seller risk, fulfillment friction, and product/category opportunity.

## Local Commands

Install dependencies:

```bash
pip install -r requirements.txt
```

Run the full local pipeline:

```bash
python src/run_pipeline.py
```

Run dbt directly:

```bash
dbt build --project-dir . --profiles-dir dbt --target-path dbt/target
```

Open the dashboard:

```bash
streamlit run dashboard/streamlit_app.py
```

Open Dagster:

```bash
$env:PYTHONPATH="src"
dagster dev -f src/orchestration/definitions.py
```

## dbt Layers

- `dbt/models/warehouse`: dimensional model with `dim_customer`, `dim_product`, `dim_seller`, `dim_date`, `fact_sales`, and `fact_order_payment`.
- `dbt/models/marts`: decision tables for executive and operational analysis.
- `dbt/tests`: data tests for fact uniqueness, non-negative sales, amount consistency, and review score validity.

## Decision Marts

| Mart | Decision use |
| --- | --- |
| `mart_platform_overview` | Executive KPI snapshot for GMV, seller base, customer base, reviews, delivery, and freight burden |
| `mart_monthly_platform_health` | Growth and health trends by month |
| `mart_seller_health` | Seller-level action segmentation: protect, grow, activate, or fix experience |
| `mart_seller_concentration` | Dependency risk from high-GMV sellers |
| `mart_category_opportunity` | Category demand, seller supply, and experience quality |
| `mart_regional_fulfillment` | Fulfillment friction by customer and seller state |

## Metric Interpretation

- `product_gmv`: item price, used as the clearest marketplace activity measure.
- `gross_transaction_value`: item price plus freight, useful for customer transaction burden.
- `order_payment_value`: order-level payment value, stored separately in `fact_order_payment` to avoid double-counting multi-item orders.
- `late_delivery_rate`: share of delivered items arriving after estimated delivery.
- `freight_to_price_ratio`: fulfillment cost burden relative to item price.
- `seller_action_segment`: practical seller-management grouping for account support and operational prioritization.

## Automation

Dagster defines four assets:

- `raw_olist_tables`: loads CSV files into DuckDB raw tables.
- `dbt_warehouse_models`: runs `dbt build`.
- `warehouse_quality_checks`: runs the original SQL quality checks.
- `dashboard_ready`: verifies the refreshed warehouse exists for Streamlit.

The included daily schedule runs at 08:00. For new data, place updated CSVs in `data/raw`, then materialize the assets in Dagster or run `python src/run_pipeline.py`.
