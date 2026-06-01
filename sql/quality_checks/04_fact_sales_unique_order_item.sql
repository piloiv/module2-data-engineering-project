SELECT COUNT(*) AS failing_rows
FROM (
    SELECT
        order_id,
        order_item_id
    FROM warehouse.fact_sales
    GROUP BY
        order_id,
        order_item_id
    HAVING COUNT(*) > 1
);
