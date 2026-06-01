SELECT COUNT(*) AS failing_rows
FROM warehouse.fact_sales AS fs
LEFT JOIN warehouse.dim_product AS dp
    ON fs.product_key = dp.product_key
WHERE fs.product_key IS NULL
   OR dp.product_key IS NULL;
