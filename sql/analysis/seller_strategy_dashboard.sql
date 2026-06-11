-- Seller-centric strategy queries for the Olist business model.
-- Item prices are treated as product GMV, not confirmed Olist revenue.

-- 1. Platform activity and seller base
SELECT
    COUNT(DISTINCT order_id) AS orders,
    COUNT(*) AS order_items,
    COUNT(DISTINCT seller_key) AS active_sellers,
    SUM(price) AS product_gmv,
    SUM(total_sale_amount) AS gross_transaction_value,
    ROUND(SUM(price) / COUNT(DISTINCT seller_key), 2) AS product_gmv_per_seller,
    ROUND(COUNT(DISTINCT order_id)::DOUBLE / COUNT(DISTINCT seller_key), 2) AS orders_per_seller,
    ROUND(AVG(review_score), 2) AS avg_review_score,
    ROUND(AVG(delivery_days), 2) AS avg_delivery_days
FROM warehouse.fact_sales;

-- 2. Active sellers and GMV trend by month
SELECT
    date_trunc('month', d.full_date)::DATE AS month_start,
    COUNT(DISTINCT fs.seller_key) AS active_sellers,
    COUNT(DISTINCT fs.order_id) AS orders,
    ROUND(SUM(fs.price), 2) AS product_gmv
FROM warehouse.fact_sales AS fs
INNER JOIN warehouse.dim_date AS d
    ON fs.order_date_key = d.date_key
GROUP BY month_start
ORDER BY month_start;

-- 3. Top sellers by GMV
SELECT
    ds.seller_id,
    ds.seller_state,
    COUNT(DISTINCT fs.order_id) AS orders,
    COUNT(*) AS items,
    ROUND(SUM(fs.price), 2) AS product_gmv,
    ROUND(SUM(fs.total_sale_amount), 2) AS gross_transaction_value,
    ROUND(AVG(fs.review_score), 2) AS avg_review,
    ROUND(AVG(fs.delivery_days), 2) AS avg_delivery_days
FROM warehouse.fact_sales AS fs
LEFT JOIN warehouse.dim_seller AS ds
    ON fs.seller_key = ds.seller_key
GROUP BY ds.seller_id, ds.seller_state
ORDER BY product_gmv DESC
LIMIT 20;

-- 4. Seller concentration risk
WITH seller_gmv AS (
    SELECT
        seller_key,
        SUM(price) AS product_gmv
    FROM warehouse.fact_sales
    GROUP BY seller_key
),
ranked AS (
    SELECT
        seller_key,
        product_gmv,
        ROW_NUMBER() OVER (ORDER BY product_gmv DESC) AS seller_rank,
        SUM(product_gmv) OVER () AS total_gmv
    FROM seller_gmv
)
SELECT
    ROUND(SUM(CASE WHEN seller_rank <= 10 THEN product_gmv ELSE 0 END) / MAX(total_gmv), 4) AS top_10_share,
    ROUND(SUM(CASE WHEN seller_rank <= 100 THEN product_gmv ELSE 0 END) / MAX(total_gmv), 4) AS top_100_share,
    ROUND(SUM(CASE WHEN seller_rank <= 500 THEN product_gmv ELSE 0 END) / MAX(total_gmv), 4) AS top_500_share
FROM ranked;

-- 5. Seller geography
SELECT
    ds.seller_state,
    COUNT(DISTINCT fs.seller_key) AS active_sellers,
    COUNT(DISTINCT fs.order_id) AS orders,
    ROUND(SUM(fs.price), 2) AS product_gmv,
    ROUND(SUM(fs.price) / COUNT(DISTINCT fs.seller_key), 2) AS product_gmv_per_seller,
    ROUND(AVG(fs.review_score), 2) AS avg_review,
    ROUND(AVG(fs.delivery_days), 2) AS avg_delivery_days
FROM warehouse.fact_sales AS fs
INNER JOIN warehouse.dim_seller AS ds
    ON fs.seller_key = ds.seller_key
GROUP BY ds.seller_state
ORDER BY product_gmv DESC;

-- 6. Seller retention and churn proxies from monthly activity
WITH seller_month AS (
    SELECT DISTINCT
        fs.seller_key,
        date_trunc('month', d.full_date)::DATE AS month_start
    FROM warehouse.fact_sales AS fs
    INNER JOIN warehouse.dim_date AS d
        ON fs.order_date_key = d.date_key
),
seller_bounds AS (
    SELECT
        seller_key,
        MIN(month_start) AS first_month,
        MAX(month_start) AS last_month,
        COUNT(*) AS active_months
    FROM seller_month
    GROUP BY seller_key
),
max_month AS (
    SELECT MAX(month_start) AS dataset_last_month
    FROM seller_month
)
SELECT
    COUNT(*) AS sellers,
    SUM(CASE WHEN active_months = 1 THEN 1 ELSE 0 END) AS one_month_sellers,
    ROUND(SUM(CASE WHEN active_months = 1 THEN 1 ELSE 0 END)::DOUBLE / COUNT(*), 4) AS one_month_seller_share,
    SUM(CASE WHEN last_month < dataset_last_month - INTERVAL 3 MONTH THEN 1 ELSE 0 END) AS inactive_before_last_3_months,
    ROUND(SUM(CASE WHEN last_month < dataset_last_month - INTERVAL 3 MONTH THEN 1 ELSE 0 END)::DOUBLE / COUNT(*), 4) AS inactive_before_last_3_months_share
FROM seller_bounds, max_month;
