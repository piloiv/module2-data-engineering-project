# Module 2 Data Engineering Project

End-to-end data pipeline and analysis project for the Module 2 assignment.

## Project Goal

Build a data pipeline that ingests raw business data, loads it into a warehouse, transforms it into a star schema, validates data quality, and produces business insights for an executive audience. The business lens is Olist as a seller enablement platform, not a direct online retailer.

## Recommended Dataset

Primary recommendation: Brazilian E-Commerce Dataset by Olist.

This dataset is well suited because it supports customers, orders, products, sellers, payments, reviews, geography, and sales analysis. Transaction values in the public dataset are treated as GMV-style marketplace activity, not confirmed Olist revenue.

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
src/
  ingestion/           Scripts to load raw files
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
- DuckDB or PostgreSQL
- Jupyter Notebook
- SQL quality checks
- Optional: dbt, Great Expectations, Airflow, Dagster, GitHub Actions

## Workflow

1. Place raw dataset files in `data/raw/`.
2. Install dependencies with `pip install -r requirements.txt`.
3. Run `python src/run_pipeline.py` to ingest raw files, build the star schema, and execute quality checks.
4. Analyze warehouse data in `notebooks/olist_warehouse_analysis.ipynb`.
5. Run seller-focused strategy queries in `sql/analysis/seller_strategy_dashboard.sql`.
6. Summarize findings in `docs/report_outline.md` and `slides/executive_deck_outline.md`.

## Warehouse Model

The DuckDB database is written to `data/warehouse/module2_project.duckdb`.

- Raw source tables are stored in the `raw` schema.
- Modeled analytics tables are stored in the `warehouse` schema.
- `warehouse.fact_sales` is one row per order item.
- Dimensions include customer, product, seller, and date.
- Seller analysis is a first-class use case because Olist's primary business customers are merchants.

## Data Quality Coverage

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
- Mermaid diagram: `docs/diagrams/pipeline_architecture.mmd`
