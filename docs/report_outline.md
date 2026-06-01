# Technical Report

## Executive Summary

This project turns raw Olist e-commerce CSV files into an analytics-ready DuckDB warehouse. The pipeline supports executive questions about sales trends, product performance, customer geography, delivery performance, and review outcomes.

## Dataset

The selected dataset is the Brazilian E-Commerce Dataset by Olist. It contains order, customer, product, seller, payment, review, and geography files. The final fact table uses one order item as its grain, allowing revenue and fulfillment analysis at a detailed transaction level.

## Architecture

See `docs/architecture.md` and `docs/diagrams/pipeline_architecture.mmd`.

## Tooling Decisions

DuckDB was selected as the warehouse because it is simple to run locally, stores the full project in one file, and performs well for analytical SQL. Python handles ingestion, orchestration, quality execution, and notebook analysis. SQL is used for transformations so the modeling logic is transparent.

## Star Schema Design

See `docs/schema_design.md`.

## Data Quality

Quality checks are implemented as SQL files in `sql/quality_checks` and executed by `src/quality/run_quality_checks.py`. They validate null keys, duplicate fact rows, customer/product/seller referential integrity, non-negative sales, amount consistency, valid review scores, and valid order statuses.

## Analysis And Insights

The analysis notebook should calculate total revenue, order count, average order value, monthly revenue, top product categories, customer geography, delivery performance, and repeat purchase behavior once the raw dataset has been loaded.

## Recommendations

Recommended executive actions should focus on high-performing categories, regions with strong demand, delivery reliability, and customer retention opportunities.

## Limitations And Future Work

The project assumes the Olist CSV files are complete and preserve the source column names. Future improvements could include scheduled orchestration, automated chart exports, dbt model tests, and a BI dashboard connected to DuckDB or a cloud warehouse.
