# Module 2 Data Engineering Project

End-to-end data pipeline and analysis project for the Module 2 assignment.

## Project Goal

Build a data pipeline that ingests raw business data, loads it into a warehouse, transforms it into a star schema, validates data quality, and produces business insights for an executive audience.

The executive storyline is framed as a management review of Olist's first observed operating years. After a period of rapid marketplace transaction growth, monthly Product GMV appears to level off through much of the second year. The business question is how Olist can reinvigorate growth by improving seller success, not by managing an owned consumer marketplace.

## Recommended Dataset

Primary recommendation: Brazilian E-Commerce Dataset by Olist.

This dataset is well suited because it supports customers, orders, products, sellers, payments, reviews, geography, and sales analysis. Transaction values in the public dataset are treated as marketplace-channel activity signals, not confirmed Olist revenue.

Olist is interpreted as a commerce enablement platform: it helps small and medium-sized sellers access multiple online channels and related operating services. The dataset contains buyer-facing order records, but the strategic customer relationship belongs primarily with sellers.

## Metric Definitions

- **Product GMV**: item/product sales value only, using `price`. It excludes freight and is not confirmed Olist revenue.
- **GTV**: gross transaction value, using `price + freight_value`. In this project, it represents product value plus freight at order-item grain.
- **Payment value**: customer payment total at order grain. It is modeled separately in `warehouse.fact_order_payment` to avoid double-counting multi-item orders.
- **CAC**: seller acquisition cost. This is a future internal Olist metric, not included in the public dataset.
- **LTV**: seller lifetime value. This is a future internal Olist metric, not included in the public dataset.

## Deliverables

- GitHub-ready project repository
- Raw data ingestion scripts
- Data warehouse schema
- ELT transformation scripts
- Data quality checks
- Jupyter notebook for analysis
- Architecture and lineage documentation
- Technical report
- Executive slide deck
- Seller-centric strategic dashboard queries

## Project Structure

```text
data/
  raw/                 Raw source files
  processed/           Optional cleaned intermediate files
  warehouse/           Local warehouse files, such as DuckDB
dashboard/             Streamlit dashboard
dbt/                   dbt sources, warehouse models, marts, and tests
src/
  ingestion/           Scripts to load raw files
  orchestration/       Dagster assets and schedule
  transformations/     Python-based ELT helpers
  quality/             Data quality checks
sql/
  schema/              Warehouse table definitions
  transforms/          SQL transformations into star schema
  quality_checks/      SQL validation checks
notebooks/             Exploratory and final analysis notebooks
docs/
  diagrams/            Architecture and lineage diagrams
slides/                Executive presentation materials
tests/                 Automated tests
config/                Project configuration
```

## Suggested Technology Stack

- Python
- pandas
- SQLAlchemy
- DuckDB
- dbt
- Streamlit
- Dagster
- Jupyter Notebook
- SQL quality checks
- Optional: Great Expectations, GitHub Actions

## Workflow

1. Place raw dataset files in `data/raw/`.
2. Install dependencies with `pip install -r requirements.txt`.
3. Run `python src/run_pipeline.py` to ingest raw files, run dbt models/tests, and execute quality checks.
4. Open the dashboard with `streamlit run dashboard/streamlit_app.py`.
5. Use Dagster with `dagster dev -f src/orchestration/definitions.py` for asset-based orchestration.
6. Analyze warehouse data in `notebooks/olist_warehouse_analysis.ipynb`.
7. Run seller-focused strategy queries in `sql/analysis/seller_strategy_dashboard.sql`.
8. Summarize findings in `docs/report_outline.md` and `slides/executive_deck_outline.md`.

## Run From A Local Clone

These commands assume Windows PowerShell. On macOS/Linux, use `python3 -m venv .venv` and `source .venv/bin/activate` instead of the Windows activation command.

1. Clone the repository and enter the project folder.

```powershell
git clone <your-repo-url>
cd Module2_Data_Engineering_Project
```

2. Create and activate a virtual environment.

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
```

3. Install dependencies.

```powershell
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
```

4. Download the Brazilian E-Commerce Public Dataset by Olist and place the CSV files in `data/raw/`.

Expected files:

```text
data/raw/olist_customers_dataset.csv
data/raw/olist_geolocation_dataset.csv
data/raw/olist_order_items_dataset.csv
data/raw/olist_order_payments_dataset.csv
data/raw/olist_order_reviews_dataset.csv
data/raw/olist_orders_dataset.csv
data/raw/olist_products_dataset.csv
data/raw/olist_sellers_dataset.csv
data/raw/product_category_name_translation.csv
```

Raw CSVs and local warehouse files are intentionally not committed to GitHub.

5. Run the full pipeline.

```powershell
python src/run_pipeline.py
```

This loads raw CSVs into DuckDB, runs `dbt build`, creates warehouse tables and decision marts, and runs SQL quality checks.

The latest saved build records 38 dbt build outcomes: 12 model builds plus 26 dbt tests. The separate SQL quality suite contains 15 checks in `sql/quality_checks`.

6. Open the Streamlit dashboard.

```powershell
streamlit run dashboard/streamlit_app.py
```

7. Optional: run dbt directly.

```powershell
dbt build --project-dir . --profiles-dir dbt --target-path dbt/target
```

8. Optional: open Dagster for orchestration.

```powershell
$env:PYTHONPATH="src"
dagster dev -f src/orchestration/definitions.py
```

In Dagster, materialize the assets to reload raw data, rebuild dbt models, run quality checks, and confirm dashboard readiness.

9. Optional: run tests.

```powershell
python -m pytest
```

## Warehouse Model

The DuckDB database is written to `data/warehouse/module2_project.duckdb`.

- Raw source tables are stored in the `raw` schema.
- Modeled analytics tables are stored in the `warehouse` schema.
- `warehouse.fact_sales` is one row per order item.
- `warehouse.fact_order_payment` is one row per order and prevents payment double-counting.
- Dimensions include customer, product, seller, and date.
- Seller analysis is a first-class use case because Olist's primary business customers are merchants rather than end consumers.
- Decision marts support Streamlit dashboarding and executive recommendations.

## Data Quality Coverage

The project reports quality coverage as 38 dbt build outcomes plus 15 SQL checks. The 38 dbt outcomes are the saved `dbt build` results: 12 model builds and 26 dbt tests.

SQL checks in `sql/quality_checks` cover:

- Null required keys
- Duplicate fact rows and dimension surrogate keys
- Customer, product, and seller referential integrity
- Non-negative and internally consistent sales amounts
- Valid review score and order status business rules

## Documentation

- Architecture: `docs/architecture.md`
- Lineage: `docs/data_lineage.md`
- Schema design: `docs/schema_design.md`
- Modernized pipeline: `docs/modernized_pipeline.md`
- Project startup template: `docs/project_startup_template.md`
- Global custom-instructions snippet: `docs/global_custom_instructions_startup_template.md`
- Source/reference folder guide: `docs/references/references_folder_guide.md`
- Mermaid diagram: `docs/diagrams/pipeline_architecture.mmd`
