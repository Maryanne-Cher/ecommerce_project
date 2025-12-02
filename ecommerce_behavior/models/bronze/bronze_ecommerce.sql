WITH oct_2019 AS (
    SELECT * 
    FROM {{ source('source', 'oct_2019') }}
)
SELECT 
    CAST(event_time AS TIMESTAMP_LTZ) AS event_time,
    event_type,
    product_id,
    category_id,
    category_code,
    brand,
    price,
    user_id,
    user_session
FROM oct_2019
LIMIT 5000000
