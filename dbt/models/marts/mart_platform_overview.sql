WITH order_item_metrics AS (
    SELECT
        count(DISTINCT order_id) AS orders,
        count(*) AS order_items,
        count(DISTINCT seller_key) AS active_sellers,
        count(DISTINCT customer_key) AS purchasing_customers,
        sum(price) AS product_gmv,
        sum(freight_value) AS freight_value,
        sum(total_sale_amount) AS gross_transaction_value,
        avg(review_score) AS avg_review_score,
        avg(delivery_days) AS avg_delivery_days,
        avg(late_delivery_flag) AS late_delivery_rate,
        avg(freight_to_price_ratio) AS avg_freight_to_price_ratio
    FROM {{ ref('fact_sales') }}
),
payment_metrics AS (
    SELECT
        sum(order_payment_value) AS order_payment_value
    FROM {{ ref('fact_order_payment') }}
)
SELECT
    m.orders,
    m.order_items,
    m.active_sellers,
    m.purchasing_customers,
    m.product_gmv,
    m.freight_value,
    m.gross_transaction_value,
    p.order_payment_value,
    m.product_gmv / nullif(m.active_sellers, 0) AS product_gmv_per_seller,
    m.orders::DOUBLE / nullif(m.active_sellers, 0) AS orders_per_seller,
    m.product_gmv / nullif(m.orders, 0) AS average_order_product_gmv,
    m.avg_review_score,
    m.avg_delivery_days,
    m.late_delivery_rate,
    m.avg_freight_to_price_ratio
FROM order_item_metrics AS m
CROSS JOIN payment_metrics AS p
