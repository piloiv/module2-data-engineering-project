SELECT COUNT(*) AS failing_rows
FROM (
    SELECT customer_key
    FROM warehouse.dim_customer
    GROUP BY customer_key
    HAVING COUNT(*) > 1
);

