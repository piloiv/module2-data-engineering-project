SELECT COUNT(*) AS failing_rows
FROM warehouse.fact_sales AS fs
LEFT JOIN warehouse.dim_seller AS ds
    ON fs.seller_key = ds.seller_key
WHERE fs.seller_key IS NULL
   OR ds.seller_key IS NULL;
