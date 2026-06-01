SELECT COUNT(*) AS failing_rows
FROM warehouse.fact_sales
WHERE review_score IS NOT NULL
  AND (review_score < 1 OR review_score > 5);
