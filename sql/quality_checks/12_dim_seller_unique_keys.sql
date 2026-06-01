SELECT COUNT(*) AS failing_rows
FROM (
    SELECT seller_key
    FROM warehouse.dim_seller
    GROUP BY seller_key
    HAVING COUNT(*) > 1
);
