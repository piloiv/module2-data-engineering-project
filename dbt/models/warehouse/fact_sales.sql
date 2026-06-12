WITH payment_by_order AS (
    SELECT
        order_id,
        sum(payment_value) AS order_payment_value,
        max(payment_installments) AS payment_installments,
        count(DISTINCT payment_type) AS payment_type_count
    FROM {{ source('raw', 'raw_order_payments') }}
    GROUP BY order_id
),
review_by_order AS (
    SELECT
        order_id,
        avg(review_score) AS review_score
    FROM {{ source('raw', 'raw_order_reviews') }}
    GROUP BY order_id
)
SELECT
    oi.order_id,
    oi.order_item_id,
    dc.customer_key,
    dp.product_key,
    ds.seller_key,
    CAST(strftime(CAST(o.order_purchase_timestamp AS DATE), '%Y%m%d') AS INTEGER) AS order_date_key,
    CAST(strftime(CAST(o.order_approved_at AS DATE), '%Y%m%d') AS INTEGER) AS approved_date_key,
    CAST(strftime(CAST(o.order_delivered_customer_date AS DATE), '%Y%m%d') AS INTEGER) AS delivered_date_key,
    CAST(strftime(CAST(o.order_estimated_delivery_date AS DATE), '%Y%m%d') AS INTEGER) AS estimated_delivery_date_key,
    o.order_status,
    oi.price,
    oi.freight_value,
    oi.price + oi.freight_value AS total_sale_amount,
    p.order_payment_value,
    p.payment_installments,
    p.payment_type_count,
    r.review_score,
    date_diff('day', CAST(o.order_purchase_timestamp AS DATE), CAST(o.order_delivered_customer_date AS DATE)) AS delivery_days,
    date_diff('day', CAST(o.order_delivered_customer_date AS DATE), CAST(o.order_estimated_delivery_date AS DATE)) AS estimated_delivery_variance_days,
    CASE
        WHEN o.order_delivered_customer_date IS NULL THEN NULL
        WHEN CAST(o.order_delivered_customer_date AS DATE) > CAST(o.order_estimated_delivery_date AS DATE) THEN 1
        ELSE 0
    END AS late_delivery_flag,
    CASE
        WHEN oi.price = 0 THEN NULL
        ELSE oi.freight_value / oi.price
    END AS freight_to_price_ratio
FROM {{ source('raw', 'raw_order_items') }} AS oi
INNER JOIN {{ source('raw', 'raw_orders') }} AS o
    ON oi.order_id = o.order_id
LEFT JOIN {{ ref('dim_customer') }} AS dc
    ON o.customer_id = dc.customer_id
LEFT JOIN {{ ref('dim_product') }} AS dp
    ON oi.product_id = dp.product_id
LEFT JOIN {{ ref('dim_seller') }} AS ds
    ON oi.seller_id = ds.seller_id
LEFT JOIN payment_by_order AS p
    ON oi.order_id = p.order_id
LEFT JOIN review_by_order AS r
    ON oi.order_id = r.order_id
