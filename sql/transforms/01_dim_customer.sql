CREATE OR REPLACE TABLE warehouse.dim_customer AS
SELECT
    row_number() OVER (ORDER BY customer_id) AS customer_key,
    customer_id,
    customer_unique_id,
    lower(trim(customer_city)) AS customer_city,
    upper(trim(customer_state)) AS customer_state
FROM raw.raw_customers;
