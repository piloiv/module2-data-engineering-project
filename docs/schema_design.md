# Star Schema Design

## Business Process

The modeled business process is e-commerce order item activity generated through marketplace channels connected to Olist's seller enablement ecosystem. Each row in `warehouse.fact_sales` represents one purchased product line within an order.

For business interpretation, item prices and freight values should be treated as marketplace-channel activity measures, not Olist revenue. Product GMV is item price only. GTV is item price plus freight. Neither measure reveals Olist commission rates, seller subscription fees, logistics margins, financial services revenue, or operating costs.

## Fact Table Grain

`warehouse.fact_sales` is at the grain of one `order_id` plus one `order_item_id`.

This grain supports the management growth case by exposing:

- Monthly Product GMV and order trends
- Product category performance
- Seller performance
- Customer geography analysis
- Delivery and review analysis
- Seller productivity, concentration, and fulfillment friction as growth levers

## Dimensions

| Dimension | Source | Description |
| --- | --- | --- |
| `dim_customer` | `raw.raw_customers` | Customer identifiers and geography |
| `dim_product` | `raw.raw_products`, `raw.raw_product_category_name_translation` | Product attributes and English category names |
| `dim_seller` | `raw.raw_sellers` | Seller identifiers and geography |
| `dim_date` | `raw.raw_orders` | Reusable date attributes for order, approval, delivery, and estimated delivery dates |

## Fact Measures

| Measure | Definition |
| --- | --- |
| `price` | Item sale price before freight; used as Product GMV |
| `freight_value` | Shipping charge for the order item |
| `total_sale_amount` | `price + freight_value`; GTV, or gross transaction value, at item grain |
| `order_payment_value` | Total payment value aggregated at order level; use carefully in item-grain tables |
| `payment_installments` | Maximum installment count used for the order |
| `payment_type_count` | Number of distinct payment methods used for the order |
| `review_score` | Average review score for the order |
| `delivery_days` | Days from purchase to customer delivery |
| `estimated_delivery_variance_days` | Positive values mean delivery happened before the estimate |

## Design Rationale

The star schema separates descriptive context into dimensions and numeric business events into fact tables. This makes common analytics queries simpler and faster because analysts can aggregate Product GMV by date, customer location, seller, and product category without repeatedly joining the raw operational tables.

The design intentionally keeps `dim_seller` connected to every order item. That makes seller health analysis a first-class use case: active sellers, Product GMV per seller, seller concentration, seller geography, delivery performance, and review outcomes can all be measured from the same validated fact table.

This is the key business-model choice in the schema. Although the dataset contains customer, payment, and review records, those buyer-side signals are modeled so management can evaluate merchant outcomes and platform operating quality. The schema therefore supports Olist's commerce enablement question: which seller, category, regional, and fulfillment levers can restart growth after the observed second-year plateau?

Order payment totals are modeled separately in `warehouse.fact_order_payment` so payment analysis can happen at order grain without double-counting multi-item orders. dbt marts build on these warehouse tables to support seller action segmentation, concentration risk, category opportunity, and regional fulfillment decisions.
