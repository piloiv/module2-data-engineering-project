SELECT *
FROM {{ ref('fact_sales') }}
WHERE abs(total_sale_amount - (price + freight_value)) > 0.01
