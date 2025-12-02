WITH bronze_data AS (
    SELECT * 
    FROM {{ source('source', 'oct_2019') }}
)
SELECT
    CAST(LEFT(event_time, 19) AS TIMESTAMP_NTZ) AS event_date_and_time,
    event_type,
    product_id,
    category_id,
    category_code,
    brand,
    price,
    user_id,
    user_session
FROM bronze_data
LIMIT 5000000
