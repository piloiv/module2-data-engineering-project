# Pipeline Architecture

## Objective

This project builds a local analytics warehouse for the Brazilian E-Commerce Dataset by Olist. The workflow ingests raw CSV files, stores them in DuckDB raw tables, transforms them into a star schema, validates the warehouse, and supports Python analysis for executive reporting.

## Components

| Layer | Tool | Purpose |
| --- | --- | --- |
| Source | Olist CSV files | Transactional e-commerce source data |
| Ingestion | Python + DuckDB | Load each raw CSV into the `raw` schema |
| Warehouse | DuckDB | Store raw and modeled data in one local database file |
| Transformation | dbt + SQL | Build reusable dimension, fact, and decision mart tables |
| Data quality | SQL checks + Python runner | Validate nulls, duplicates, references, and business rules |
| Dashboard | Streamlit + DuckDB + Plotly | Present seller-enablement metrics and decision views |
| Orchestration | Dagster | Automate ingestion, dbt build, quality checks, and dashboard readiness |
| Analysis | Jupyter + pandas + SQLAlchemy/DuckDB | Calculate trends, segments, and recommendations |
| Documentation | Markdown + Mermaid | Explain architecture, lineage, schema, and decisions |

## Processing Flow

1. Place the Olist CSV files in `data/raw`.
2. Run `python src/run_pipeline.py`.
3. The ingestion step creates `raw.*` tables in `data/warehouse/module2_project.duckdb`.
4. dbt creates the `warehouse` star schema and decision marts.
5. dbt tests and SQL quality checks validate the warehouse.
6. Streamlit reads the marts for dashboard views.
7. Dagster can orchestrate the same workflow when new raw files are added.
8. Analysts query the modeled tables from notebooks and presentation materials.

## Tool Choices

DuckDB is used because it is lightweight, file-based, SQL-friendly, and strong for local analytical workloads. dbt keeps transformation logic modular, testable, and documented. Python is used for ingestion, quality execution, orchestration hooks, and analysis because it connects naturally to pandas, notebooks, Dagster, and visualization libraries.
