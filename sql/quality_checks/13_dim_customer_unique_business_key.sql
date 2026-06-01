SELECT COUNT(*) AS failing_rows
FROM (
    SELECT customer_id
    FROM warehouse.dim_customer
    GROUP BY customer_id
    HAVING COUNT(*) > 1
);
