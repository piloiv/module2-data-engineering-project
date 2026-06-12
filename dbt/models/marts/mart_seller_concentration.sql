WITH seller_gmv AS (
    SELECT
        seller_key,
        product_gmv
    FROM {{ ref('mart_seller_health') }}
),
ranked AS (
    SELECT
        seller_key,
        product_gmv,
        row_number() OVER (ORDER BY product_gmv DESC) AS seller_rank,
        sum(product_gmv) OVER () AS total_product_gmv
    FROM seller_gmv
)
SELECT
    seller_rank,
    seller_key,
    product_gmv,
    total_product_gmv,
    product_gmv / nullif(total_product_gmv, 0) AS product_gmv_share,
    sum(product_gmv) OVER (ORDER BY seller_rank ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
        / nullif(total_product_gmv, 0) AS cumulative_product_gmv_share
FROM ranked
