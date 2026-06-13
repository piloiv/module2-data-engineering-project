# Technical Report

## Executive Summary

This project turns raw Olist e-commerce CSV files into an analytics-ready DuckDB warehouse. The executive lens is a management review of Olist's first observed operating years: after rapid early growth, monthly Product GMV appears to plateau through much of 2018, so management needs to identify the best levers to reinvigorate growth.

The analysis frames Olist as a commerce enablement platform, not an owned consumer marketplace. The public data shows marketplace-channel transaction activity, while Olist's strategic value depends on helping sellers grow, fulfill reliably, and stay on the platform.

## Dataset

The selected dataset is the Brazilian E-Commerce Dataset by Olist. It contains order, customer, product, seller, payment, review, and geography files. The final fact table uses one order item as its grain, allowing GMV, seller, product, customer, and fulfillment analysis at a detailed transaction level.

The observed order-item window runs from September 4, 2016 to September 3, 2018. The business review focuses on October 2016 through September 2018, while treating the tiny September 2016 and September 2018 tails as partial-period artifacts.

The dataset should not be interpreted as Olist's full income statement. Item prices and freight values represent commerce flowing through the marketplace ecosystem, but they do not reveal Olist's actual take rate, SaaS subscription revenue, logistics margin, financial services revenue, or profitability.

## Metric Definitions

- **Product GMV**: item/product sales value only, using `price`; excludes freight and is not confirmed Olist revenue.
- **GTV**: gross transaction value, using `price + freight_value`; in this project, product value plus freight.
- **Payment value**: customer payment total at order grain, modeled separately to avoid double-counting multi-item orders.
- **CAC**: seller acquisition cost; a future internal metric not available in the public dataset.
- **LTV**: seller lifetime value; a future internal metric not available in the public dataset.

## Architecture

See `docs/architecture.md` and `docs/diagrams/pipeline_architecture.mmd`.

## Tooling Decisions

DuckDB was selected as the warehouse because it is simple to run locally, stores the full project in one file, and performs well for analytical SQL. Python handles ingestion, orchestration, quality execution, and notebook analysis. SQL is used for transformations so the modeling logic is transparent.

## Star Schema Design

See `docs/schema_design.md`.

## Data Quality

Quality checks are implemented as SQL files in `sql/quality_checks` and executed by `src/quality/run_quality_checks.py`. They validate null keys, duplicate fact rows, customer/product/seller referential integrity, non-negative sales, amount consistency, valid review scores, and valid order statuses.

The latest saved validation summary is 38 dbt build outcomes plus 15 SQL checks. The dbt count includes 12 model builds and 26 dbt tests; the SQL count is the 15 files in `sql/quality_checks`.

## Business Model Alignment

Olist's primary clients are sellers, especially small and medium-sized merchants that need access to multiple marketplaces, order management, logistics support, and related services. End consumers generate the order data, but they are not the main paying customer relationship for Olist.

This distinction matters because the dataset can look like a consumer marketplace dataset. Strategically, however, Olist creates value by helping merchants reach marketplace buyers and operate more effectively across channels. The dashboard therefore treats buyer orders, payments, reviews, and delivery outcomes as evidence of seller success and platform health.

This means the analysis should answer two connected questions:

- How much commerce is flowing through the platform?
- Which sellers, regions, product categories, and operational issues most affect seller success and retention?
- Which growth levers can move the second-year plateau: seller productivity, seller activation, category expansion, fulfillment reliability, regional coverage, or customer repeat demand?

## Analysis And Insights

The analysis notebook should calculate Product GMV, GTV, order count, average order value, monthly Product GMV, active sellers, Product GMV per seller, seller concentration, top product categories, customer geography, delivery performance, review outcomes, and repeat purchase behavior once the raw dataset has been loaded.

The first-pass readout shows Year 1 activity of 27,245 orders and about 3.79M product GMV from October 2016 through September 2017, followed by Year 2 activity of 71,418 orders and about 9.80M product GMV from October 2017 through September 2018. The more important management signal is not the annual total alone: monthly product GMV rises quickly, then spends much of 2018 around the 850k-1.0M range even as active sellers continue increasing. That pattern suggests growth is shifting from pure acquisition to productivity and operating quality.

The seller strategy dashboard should add:

- Active sellers by month
- Top sellers by Product GMV, order volume, review score, and delivery time
- Top seller concentration as a platform dependency risk
- Seller performance by state and product category
- Seller retention and churn proxies based on monthly activity

## Recommendations

Recommended executive actions should focus on seller retention, seller productivity, high-performing categories, regions with strong demand, fulfillment reliability, and selective customer retention opportunities that help sellers generate repeat demand.

Short-term priorities should be:

- Protect and grow high-performing sellers through account support and targeted operational improvements.
- Improve delivery reliability in weak corridors because logistics performance affects seller reviews and seller retention.
- Use product and regional demand signals to help sellers decide where to expand assortment.
- Activate lower-productivity sellers with category, pricing, logistics, and marketplace-channel playbooks.

The executive deck summarizes these into 13 growth levers: protect high-Product GMV sellers; grow healthy mid-tail sellers; fix experience-risk sellers; activate one-month or underdeveloped sellers; reduce concentration dependency by expanding the healthy mid-tail; prioritize proven-demand categories; deepen assortment in large categories; improve stock readiness; monitor category fulfillment risk; follow up reviews in priority categories; fix weak carrier corridors; improve seller location mix or regional coverage; and improve estimated delivery-date accuracy.

Long-term priorities should be:

- Reduce dependence on pure transaction commissions by expanding seller software, logistics, and financial services.
- Monitor seller concentration risk so Olist is not overly dependent on a small number of merchants.
- Build internal data assets for true Olist revenue, take rate, seller LTV, seller CAC, and profitability.

## Limitations And Future Work

The project assumes the Olist CSV files are complete and preserve the source column names. The public dataset does not include Olist commission rates, subscription revenue, logistics cost, financial services revenue, marketplace source, seller acquisition cost, or operating expenses. Future improvements could include scheduled orchestration, automated chart exports, dbt model tests, a BI dashboard connected to DuckDB or a cloud warehouse, and integration with internal Olist financial and seller lifecycle data.
