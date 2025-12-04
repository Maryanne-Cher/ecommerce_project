{{
    config(
        unique_key='event_key'
    )
}}


WITH silver_data AS (
    SELECT * FROM  {{ ref('bronze_ecommerce') }}
)

SELECT
    event_key,
    event_date_and_time,
    CAST(LEFT(event_date_and_time, 19) AS DATE) AS event_date,
    CAST(TRY_TO_TIMESTAMP_NTZ(LEFT(event_date_and_time, 19)) AS TIME) AS event_time_only,
    event_type,
    product_id,
    category_id,
        CASE
        WHEN POSITION('.' IN category_code) > 0
            THEN SPLIT_PART(category_code, '.', 1)
        ELSE 'UNKNOWN'
    END AS category,
    CASE 
        WHEN POSITION('.' IN category_code) > 0
            THEN SPLIT_PART(category_code, '.', 2)
        ELSE 'UNKNOWN'
    END AS subcategory,
    COALESCE(brand, 'UNKNOWN') AS brand,
    price,
    user_id,
    COALESCE(user_session, 'UNKNOWN') AS user_session
FROM silver_data

{% if is_incremental() %}
 --Only insert rows that are new based on surrogate key
WHERE event_key NOT IN (SELECT event_key FROM {{ this }})
{% endif %}