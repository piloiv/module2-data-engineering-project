SELECT COUNT(*) AS failing_rows
FROM warehouse.fact_sales
WHERE order_id IS NULL;

