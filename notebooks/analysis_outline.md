# Analysis Notebook Outline

The working notebook is `notebooks/olist_warehouse_analysis.ipynb`. Use this outline as the checklist for final polish after the raw CSVs are loaded.

## Sections

1. Connect to the warehouse with SQLAlchemy or DuckDB.
2. Inspect table row counts and sample records.
3. Calculate monthly Product GMV trends.
4. Identify top-selling product categories.
5. Analyze seller performance, active sellers, seller concentration, and seller retention proxies.
6. Segment customers by purchase frequency and total spend.
7. Visualize key findings.
8. Summarize business recommendations.

## Suggested Metrics

- Product GMV
- GTV, or gross transaction value
- Number of orders
- Average order value
- Monthly Product GMV trend
- Active sellers
- Product GMV per seller
- Top seller concentration
- Seller review and delivery performance
- Top product categories
- Top customer states/cities
- Repeat customer behavior

## Metric Definitions

- Product GMV = item/product sales value only, excluding freight.
- GTV = Product GMV plus freight.
- Payment value = order-level customer payment total, kept separate to avoid double-counting.
- CAC = seller acquisition cost, not available in the public dataset.
- LTV = seller lifetime value, not available in the public dataset.
