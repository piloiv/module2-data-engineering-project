CREATE OR REPLACE TABLE warehouse.dim_product AS
SELECT
    row_number() OVER (ORDER BY p.product_id) AS product_key,
    p.product_id,
    p.product_category_name,
    coalesce(t.product_category_name_english, p.product_category_name) AS product_category_name_english,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm
FROM raw.raw_products AS p
LEFT JOIN raw.raw_product_category_name_translation AS t
    ON p.product_category_name = t.product_category_name;
