SELECT COUNT(*) AS failing_rows
FROM warehouse.fact_sales
WHERE order_status NOT IN (
    'approved',
    'canceled',
    'created',
    'delivered',
    'invoiced',
    'processing',
    'shipped',
    'unavailable'
);
