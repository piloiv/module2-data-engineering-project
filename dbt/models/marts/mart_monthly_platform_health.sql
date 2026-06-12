SELECT
    date_trunc('month', d.full_date)::DATE AS month_start,
    count(DISTINCT fs.order_id) AS orders,
    count(*) AS order_items,
    count(DISTINCT fs.seller_key) AS active_sellers,
    count(DISTINCT fs.customer_key) AS purchasing_customers,
    sum(fs.price) AS product_gmv,
    sum(fs.total_sale_amount) AS gross_transaction_value,
    sum(fs.price) / nullif(count(DISTINCT fs.seller_key), 0) AS product_gmv_per_seller,
    avg(fs.review_score) AS avg_review_score,
    avg(fs.delivery_days) AS avg_delivery_days,
    avg(fs.late_delivery_flag) AS late_delivery_rate
FROM {{ ref('fact_sales') }} AS fs
INNER JOIN {{ ref('dim_date') }} AS d
    ON fs.order_date_key = d.date_key
GROUP BY month_start
