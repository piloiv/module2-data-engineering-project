SELECT
    dc.customer_state,
    ds.seller_state,
    count(DISTINCT fs.order_id) AS orders,
    count(*) AS order_items,
    count(DISTINCT fs.seller_key) AS active_sellers,
    sum(fs.price) AS product_gmv,
    avg(fs.review_score) AS avg_review_score,
    avg(fs.delivery_days) AS avg_delivery_days,
    avg(fs.late_delivery_flag) AS late_delivery_rate,
    avg(fs.freight_to_price_ratio) AS avg_freight_to_price_ratio
FROM {{ ref('fact_sales') }} AS fs
INNER JOIN {{ ref('dim_customer') }} AS dc
    ON fs.customer_key = dc.customer_key
INNER JOIN {{ ref('dim_seller') }} AS ds
    ON fs.seller_key = ds.seller_key
GROUP BY dc.customer_state, ds.seller_state
