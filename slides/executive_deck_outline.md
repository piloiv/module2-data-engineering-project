# Executive Slide Deck Outline

Recommended duration: 10 minutes presentation plus 5 minutes Q&A.

## Slide 1: Olist Seller Enablement Analytics Warehouse

Message: We built an end-to-end warehouse and analysis workflow that converts raw marketplace data into executive-ready seller, GMV, product, customer, and delivery insights.

## Slide 2: Business Case

Message: The business case is seller success, not direct retail sales. Public transaction data should be used to identify where Olist can protect sellers, remove friction, and expand seller services.

## Slide 3: Business Model

Message: Olist connects SMEs to marketplaces and monetizes seller enablement. Orders and buyers create the data trail, but sellers are Olist's primary clients.

## Slide 4: Executive Summary

Message: Olist is best understood as a seller enablement platform, not a direct retailer. The solution creates a validated star schema that helps executives understand platform activity and seller success.

## Slide 5: Pipeline Architecture

Message: CSV files flow into DuckDB raw tables, SQL transformations build the star schema, quality checks validate the warehouse, and Python notebooks produce insights.

## Slide 6: Data Warehouse Design

Message: `fact_sales` sits at order-item grain and joins to customer, product, seller, and date dimensions for efficient analysis. Transaction values are interpreted as GMV-style activity, not confirmed Olist revenue.

## Slide 7: Data Quality

Message: The project protects against null keys, duplicated order items, broken dimension joins, invalid business values, and inconsistent sales calculations.

## Slide 8: Platform Growth

Message: Show product GMV, gross transaction value, order count, average order value, active sellers, and monthly GMV movement.

## Slide 9: Product And Demand Signals

Message: Rank product categories, customer states, and demand patterns to show where Olist can help sellers expand assortment and regional coverage.

## Slide 10: Regional Concentration

Message: Show Sao Paulo as the demand engine and delivery benchmark, while identifying regional demand pockets where fulfillment may constrain seller growth.

## Slide 11: Operations And Customer Experience

Message: Use delivery time, late delivery risk, freight burden, and review score to identify fulfillment improvements that protect seller performance.

## Slide 12: Seller Health

Message: Highlight active sellers, GMV per seller, top seller concentration, top sellers by GMV, and seller retention/churn proxies.

## Slide 13: Roadmap

Message: Recommend seller retention, account support for high-GMV sellers, logistics improvements, category expansion, and seller service upsell opportunities.

## Slide 14: Conclusion And Way Forward

Message: Use the current analytics as the public-data foundation; the next decision layer should connect seller activity to Olist revenue, retention, and service expansion.

## Slide 15: Close

Message: Close on the seller-focused platform operating view and reinforce that the warehouse provides a repeatable, quality-checked basis for decision making.
