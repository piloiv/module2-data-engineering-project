SELECT
    coalesce(dp.product_category_name_english, 'unknown') AS product_category,
    count(DISTINCT fs.order_id) AS orders,
    count(*) AS order_items,
    count(DISTINCT fs.seller_key) AS active_sellers,
    sum(fs.price) AS product_gmv,
    sum(fs.total_sale_amount) AS gross_transaction_value,
    sum(fs.price) / nullif(count(DISTINCT fs.seller_key), 0) AS product_gmv_per_seller,
    avg(fs.review_score) AS avg_review_score,
    avg(fs.delivery_days) AS avg_delivery_days,
    avg(fs.late_delivery_flag) AS late_delivery_rate,
    avg(fs.freight_to_price_ratio) AS avg_freight_to_price_ratio
FROM {{ ref('fact_sales') }} AS fs
LEFT JOIN {{ ref('dim_product') }} AS dp
    ON fs.product_key = dp.product_key
GROUP BY product_category
