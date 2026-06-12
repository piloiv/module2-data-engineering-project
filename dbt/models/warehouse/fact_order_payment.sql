SELECT
    order_id,
    sum(payment_value) AS order_payment_value,
    max(payment_installments) AS max_payment_installments,
    count(DISTINCT payment_type) AS payment_type_count,
    string_agg(DISTINCT payment_type, ', ' ORDER BY payment_type) AS payment_types
FROM {{ source('raw', 'raw_order_payments') }}
GROUP BY order_id
