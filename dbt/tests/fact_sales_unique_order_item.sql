SELECT
    order_id,
    order_item_id
FROM {{ ref('fact_sales') }}
GROUP BY order_id, order_item_id
HAVING count(*) > 1
