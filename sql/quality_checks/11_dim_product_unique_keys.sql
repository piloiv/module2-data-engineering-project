SELECT COUNT(*) AS failing_rows
FROM (
    SELECT product_key
    FROM warehouse.dim_product
    GROUP BY product_key
    HAVING COUNT(*) > 1
);
