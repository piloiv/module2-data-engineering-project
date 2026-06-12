SELECT
    row_number() OVER (ORDER BY seller_id) AS seller_key,
    seller_id,
    lower(trim(seller_city)) AS seller_city,
    upper(trim(seller_state)) AS seller_state
FROM {{ source('raw', 'raw_sellers') }}
