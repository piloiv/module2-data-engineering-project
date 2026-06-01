# Executive Slide Deck Outline

Recommended duration: 10 minutes presentation plus 5 minutes Q&A.

## Slide 1: Olist E-Commerce Analytics Warehouse

Message: We built an end-to-end warehouse and analysis workflow that converts raw marketplace data into executive-ready sales, customer, product, and delivery insights.

## Slide 2: Executive Summary

Message: Raw operational data is difficult for executives to use directly. The solution creates a validated star schema that supports repeatable reporting and faster business decisions.

## Slide 3: Pipeline Architecture

Message: CSV files flow into DuckDB raw tables, SQL transformations build the star schema, quality checks validate the warehouse, and Python notebooks produce insights.

## Slide 4: Data Warehouse Design

Message: `fact_sales` sits at order-item grain and joins to customer, product, seller, and date dimensions for efficient analysis.

## Slide 5: Data Quality

Message: The project protects against null keys, duplicated order items, broken dimension joins, invalid business values, and inconsistent sales calculations.

## Slide 6: Sales Performance

Message: Show total revenue, order count, average order value, and monthly revenue movement.

## Slide 7: Product Insights

Message: Rank English product categories by revenue and order volume, then explain where growth or margin opportunities may exist.

## Slide 8: Customer Insights

Message: Segment customers by purchase frequency, spend level, and geography to identify retention and regional growth opportunities.

## Slide 9: Recommendations

Message: Recommend category focus, regional targeting, fulfillment improvements, and customer retention actions based on notebook findings.

## Slide 10: Risks, Limitations, And Next Steps

Message: Discuss local-file limitations, source data assumptions, potential orchestration, dashboarding, and cloud warehouse migration.
