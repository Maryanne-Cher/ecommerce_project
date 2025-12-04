{{
    config(
        unique_key='product_id'
    )
}}

WITH silver_product_info AS (
    SELECT *
    FROM {{ ref('silver_ecommerce') }}
),

ranked_products AS (
    SELECT
        product_id,
        category_id,
        brand,
        ROW_NUMBER() OVER (
            PARTITION BY product_id
            ORDER BY category_id, brand 
        ) AS rn
    FROM silver_product_info
)

SELECT
    product_id,
    category_id,
    brand
FROM ranked_products
WHERE rn = 1
{% if is_incremental() %}
AND product_id NOT IN (SELECT product_id FROM {{ this }})
{% endif %}