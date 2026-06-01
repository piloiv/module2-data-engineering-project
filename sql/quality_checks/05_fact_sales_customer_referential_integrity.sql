SELECT COUNT(*) AS failing_rows
FROM warehouse.fact_sales AS fs
LEFT JOIN warehouse.dim_customer AS dc
    ON fs.customer_key = dc.customer_key
WHERE fs.customer_key IS NULL
   OR dc.customer_key IS NULL;
