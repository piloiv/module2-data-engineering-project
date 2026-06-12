SELECT *
FROM {{ ref('fact_sales') }}
WHERE total_sale_amount < 0
