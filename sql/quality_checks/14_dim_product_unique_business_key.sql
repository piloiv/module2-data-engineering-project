SELECT COUNT(*) AS failing_rows
FROM (
    SELECT product_id
    FROM warehouse.dim_product
    GROUP BY product_id
    HAVING COUNT(*) > 1
);
