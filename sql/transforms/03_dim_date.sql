CREATE OR REPLACE TABLE warehouse.dim_date AS
WITH dates AS (
    SELECT DISTINCT CAST(order_purchase_timestamp AS DATE) AS full_date
    FROM raw.raw_orders
    WHERE order_purchase_timestamp IS NOT NULL
    UNION
    SELECT DISTINCT CAST(order_approved_at AS DATE) AS full_date
    FROM raw.raw_orders
    WHERE order_approved_at IS NOT NULL
    UNION
    SELECT DISTINCT CAST(order_delivered_customer_date AS DATE) AS full_date
    FROM raw.raw_orders
    WHERE order_delivered_customer_date IS NOT NULL
    UNION
    SELECT DISTINCT CAST(order_estimated_delivery_date AS DATE) AS full_date
    FROM raw.raw_orders
    WHERE order_estimated_delivery_date IS NOT NULL
)
SELECT
    CAST(strftime(full_date, '%Y%m%d') AS INTEGER) AS date_key,
    full_date,
    year(full_date) AS year,
    quarter(full_date) AS quarter,
    month(full_date) AS month,
    strftime(full_date, '%B') AS month_name,
    day(full_date) AS day_of_month,
    dayofweek(full_date) AS day_of_week
FROM dates;
