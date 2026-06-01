SELECT COUNT(*) AS failing_rows
FROM warehouse.fact_sales
WHERE total_sale_amount < 0;

