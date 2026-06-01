CREATE SCHEMA IF NOT EXISTS warehouse;

CREATE TABLE IF NOT EXISTS warehouse.dim_customer (
    customer_key BIGINT,
    customer_id VARCHAR,
    customer_unique_id VARCHAR,
    customer_city VARCHAR,
    customer_state VARCHAR
);

CREATE TABLE IF NOT EXISTS warehouse.dim_product (
    product_key BIGINT,
    product_id VARCHAR,
    product_category_name VARCHAR,
    product_category_name_english VARCHAR,
    product_weight_g DOUBLE,
    product_length_cm DOUBLE,
    product_height_cm DOUBLE,
    product_width_cm DOUBLE
);

CREATE TABLE IF NOT EXISTS warehouse.dim_seller (
    seller_key BIGINT,
    seller_id VARCHAR,
    seller_city VARCHAR,
    seller_state VARCHAR
);

CREATE TABLE IF NOT EXISTS warehouse.dim_date (
    date_key INTEGER,
    full_date DATE,
    year INTEGER,
    quarter INTEGER,
    month INTEGER,
    month_name VARCHAR,
    day_of_month INTEGER,
    day_of_week INTEGER
);

CREATE TABLE IF NOT EXISTS warehouse.fact_sales (
    order_id VARCHAR,
    order_item_id INTEGER,
    customer_key BIGINT,
    product_key BIGINT,
    seller_key BIGINT,
    order_date_key INTEGER,
    approved_date_key INTEGER,
    delivered_date_key INTEGER,
    estimated_delivery_date_key INTEGER,
    order_status VARCHAR,
    price DOUBLE,
    freight_value DOUBLE,
    total_sale_amount DOUBLE,
    payment_value DOUBLE,
    payment_installments INTEGER,
    payment_type_count INTEGER,
    review_score DOUBLE,
    delivery_days INTEGER,
    estimated_delivery_variance_days INTEGER
);
