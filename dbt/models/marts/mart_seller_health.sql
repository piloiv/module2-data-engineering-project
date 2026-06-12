WITH seller_month AS (
    SELECT DISTINCT
        fs.seller_key,
        date_trunc('month', d.full_date)::DATE AS month_start
    FROM {{ ref('fact_sales') }} AS fs
    INNER JOIN {{ ref('dim_date') }} AS d
        ON fs.order_date_key = d.date_key
),
seller_bounds AS (
    SELECT
        seller_key,
        min(month_start) AS first_active_month,
        max(month_start) AS last_active_month,
        count(*) AS active_months
    FROM seller_month
    GROUP BY seller_key
),
seller_metrics AS (
    SELECT
        fs.seller_key,
        count(DISTINCT fs.order_id) AS orders,
        count(*) AS order_items,
        sum(fs.price) AS product_gmv,
        sum(fs.total_sale_amount) AS gross_transaction_value,
        avg(fs.review_score) AS avg_review_score,
        avg(fs.delivery_days) AS avg_delivery_days,
        avg(fs.late_delivery_flag) AS late_delivery_rate,
        avg(fs.freight_to_price_ratio) AS avg_freight_to_price_ratio
    FROM {{ ref('fact_sales') }} AS fs
    GROUP BY fs.seller_key
),
dataset_bounds AS (
    SELECT max(month_start) AS dataset_last_month
    FROM seller_month
)
SELECT
    ds.seller_id,
    ds.seller_city,
    ds.seller_state,
    sm.seller_key,
    sm.orders,
    sm.order_items,
    sm.product_gmv,
    sm.gross_transaction_value,
    sm.product_gmv / nullif(sm.orders, 0) AS product_gmv_per_order,
    sm.avg_review_score,
    sm.avg_delivery_days,
    sm.late_delivery_rate,
    sm.avg_freight_to_price_ratio,
    sb.first_active_month,
    sb.last_active_month,
    sb.active_months,
    CASE WHEN sb.active_months = 1 THEN 1 ELSE 0 END AS one_month_seller_flag,
    CASE WHEN sb.last_active_month < db.dataset_last_month - INTERVAL 3 MONTH THEN 1 ELSE 0 END AS inactive_before_last_3_months_flag,
    ntile(10) OVER (ORDER BY sm.product_gmv DESC) AS gmv_decile,
    CASE
        WHEN sm.product_gmv >= quantile_cont(sm.product_gmv, 0.9) OVER () THEN 'protect'
        WHEN sm.avg_review_score < 3.5 OR sm.late_delivery_rate > 0.2 THEN 'fix experience'
        WHEN sb.active_months = 1 THEN 'activate'
        ELSE 'grow'
    END AS seller_action_segment
FROM seller_metrics AS sm
INNER JOIN {{ ref('dim_seller') }} AS ds
    ON sm.seller_key = ds.seller_key
INNER JOIN seller_bounds AS sb
    ON sm.seller_key = sb.seller_key
CROSS JOIN dataset_bounds AS db
