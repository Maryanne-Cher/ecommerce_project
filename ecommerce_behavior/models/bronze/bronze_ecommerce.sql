{{ 
  config(
    unique_key= 'event_key',
    )
}}

WITH bronze_data AS (
    (
        SELECT * FROM {{ source('source', 'oct_2019') }}
        {{ limit_rows() }}
    )

    UNION ALL

    (
        (SELECT * FROM {{ source('source', 'nov_2019')}})
        {{ limit_rows() }}

    )

    UNION ALL

    (
        (SELECT * FROM {{ source('source', 'dec_2019')}})
        {{ limit_rows() }}

    )

    UNION ALL

    (
        (SELECT * FROM {{ source('source', 'jan_2020')}})
        {{ limit_rows() }}

    )
    
    UNION ALL

    (
        (SELECT * FROM {{ source('source', 'feb_2020')}})
        {{ limit_rows() }}

    )
)

SELECT
    UUID_STRING() AS event_key,
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


{% if is_incremental() %}
-- Only insert rows that are new based on surrogate key
WHERE event_key NOT IN (SELECT event_key FROM {{ this }})
{% endif %}