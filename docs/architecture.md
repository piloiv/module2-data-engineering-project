# Pipeline Architecture

## Objective

This project builds a local analytics warehouse for the Brazilian E-Commerce Dataset by Olist. The workflow ingests raw CSV files, stores them in DuckDB raw tables, transforms them into a star schema, validates the warehouse, and supports Python analysis for executive reporting.

## Components

| Layer | Tool | Purpose |
| --- | --- | --- |
| Source | Olist CSV files | Transactional e-commerce source data |
| Ingestion | Python + DuckDB | Load each raw CSV into the `raw` schema |
| Warehouse | DuckDB | Store raw and modeled data in one local database file |
| Transformation | SQL | Build reusable dimension and fact tables |
| Data quality | SQL checks + Python runner | Validate nulls, duplicates, references, and business rules |
| Analysis | Jupyter + pandas + SQLAlchemy/DuckDB | Calculate trends, segments, and recommendations |
| Documentation | Markdown + Mermaid | Explain architecture, lineage, schema, and decisions |

## Processing Flow

1. Place the Olist CSV files in `data/raw`.
2. Run `python src/run_pipeline.py`.
3. The ingestion step creates `raw.*` tables in `data/warehouse/module2_project.duckdb`.
4. The transformation step creates the `warehouse` star schema.
5. The quality step runs every SQL file in `sql/quality_checks`.
6. Analysts query the modeled tables from notebooks and presentation materials.

## Tool Choices

DuckDB is used because it is lightweight, file-based, SQL-friendly, and strong for local analytical workloads. SQL transformations keep the business logic transparent and easy to review. Python is used for orchestration and analysis because it connects naturally to pandas, notebooks, and visualization libraries.
