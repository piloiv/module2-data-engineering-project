SELECT COUNT(*) AS failing_rows
FROM (
    SELECT seller_id
    FROM warehouse.dim_seller
    GROUP BY seller_id
    HAVING COUNT(*) > 1
);
