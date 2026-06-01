# Star Schema Design

## Business Process

The modeled business process is e-commerce order item sales. Each row in `warehouse.fact_sales` represents one purchased product line within an order.

## Fact Table Grain

`warehouse.fact_sales` is at the grain of one `order_id` plus one `order_item_id`.

This grain supports:

- Monthly revenue and order trends
- Product category performance
- Seller performance
- Customer geography analysis
- Delivery and review analysis

## Dimensions

| Dimension | Source | Description |
| --- | --- | --- |
| `dim_customer` | `raw.customers` | Customer identifiers and geography |
| `dim_product` | `raw.products`, `raw.product_category_name_translation` | Product attributes and English category names |
| `dim_seller` | `raw.sellers` | Seller identifiers and geography |
| `dim_date` | `raw.orders` | Reusable date attributes for order, approval, delivery, and estimated delivery dates |

## Fact Measures

| Measure | Definition |
| --- | --- |
| `price` | Item sale price before freight |
| `freight_value` | Shipping charge for the order item |
| `total_sale_amount` | `price + freight_value` |
| `payment_value` | Total payment value aggregated at order level |
| `payment_installments` | Maximum installment count used for the order |
| `payment_type_count` | Number of distinct payment methods used for the order |
| `review_score` | Average review score for the order |
| `delivery_days` | Days from purchase to customer delivery |
| `estimated_delivery_variance_days` | Positive values mean delivery happened before the estimate |

## Design Rationale

The star schema separates descriptive context into dimensions and numeric business events into the fact table. This makes common analytics queries simpler and faster because analysts can aggregate sales by date, customer location, seller, and product category without repeatedly joining the raw operational tables.
