# Technical Report

## Executive Summary

This project turns raw Olist e-commerce CSV files into an analytics-ready DuckDB warehouse. The executive lens is Olist as a seller enablement platform: the public data shows marketplace transaction activity, while Olist's strategic value depends on helping sellers grow, fulfill reliably, and stay on the platform.

## Dataset

The selected dataset is the Brazilian E-Commerce Dataset by Olist. It contains order, customer, product, seller, payment, review, and geography files. The final fact table uses one order item as its grain, allowing GMV, seller, product, customer, and fulfillment analysis at a detailed transaction level.

The dataset should not be interpreted as Olist's full income statement. Item prices and freight values represent commerce flowing through the marketplace ecosystem. They are useful as GMV-style activity measures, but they do not reveal Olist's actual take rate, SaaS subscription revenue, logistics margin, financial services revenue, or profitability.

## Architecture

See `docs/architecture.md` and `docs/diagrams/pipeline_architecture.mmd`.

## Tooling Decisions

DuckDB was selected as the warehouse because it is simple to run locally, stores the full project in one file, and performs well for analytical SQL. Python handles ingestion, orchestration, quality execution, and notebook analysis. SQL is used for transformations so the modeling logic is transparent.

## Star Schema Design

See `docs/schema_design.md`.

## Data Quality

Quality checks are implemented as SQL files in `sql/quality_checks` and executed by `src/quality/run_quality_checks.py`. They validate null keys, duplicate fact rows, customer/product/seller referential integrity, non-negative sales, amount consistency, valid review scores, and valid order statuses.

## Business Model Alignment

Olist's primary clients are sellers, especially small and medium-sized merchants that need access to multiple marketplaces, order management, logistics support, and related services. End consumers generate the order data, but they are not the main paying customer relationship for Olist.

This means the analysis should answer two connected questions:

- How much commerce is flowing through the platform?
- Which sellers, regions, product categories, and operational issues most affect seller success and retention?

## Analysis And Insights

The analysis notebook should calculate GMV, order count, average order value, monthly GMV, active sellers, GMV per seller, seller concentration, top product categories, customer geography, delivery performance, review outcomes, and repeat purchase behavior once the raw dataset has been loaded.

The seller strategy dashboard should add:

- Active sellers by month
- Top sellers by GMV, order volume, review score, and delivery time
- Top seller concentration as a platform dependency risk
- Seller performance by state and product category
- Seller retention and churn proxies based on monthly activity

## Recommendations

Recommended executive actions should focus on seller retention, seller productivity, high-performing categories, regions with strong demand, fulfillment reliability, and selective customer retention opportunities that help sellers generate repeat demand.

Short-term priorities should be:

- Protect and grow high-performing sellers through account support and targeted operational improvements.
- Improve delivery reliability in weak corridors because logistics performance affects seller reviews and seller retention.
- Use product and regional demand signals to help sellers decide where to expand assortment.

Long-term priorities should be:

- Reduce dependence on pure transaction commissions by expanding seller software, logistics, and financial services.
- Monitor seller concentration risk so Olist is not overly dependent on a small number of merchants.
- Build internal data assets for true Olist revenue, take rate, seller lifetime value, seller acquisition cost, and profitability.

## Limitations And Future Work

The project assumes the Olist CSV files are complete and preserve the source column names. The public dataset does not include Olist commission rates, subscription revenue, logistics cost, financial services revenue, marketplace source, seller acquisition cost, or operating expenses. Future improvements could include scheduled orchestration, automated chart exports, dbt model tests, a BI dashboard connected to DuckDB or a cloud warehouse, and integration with internal Olist financial and seller lifecycle data.
