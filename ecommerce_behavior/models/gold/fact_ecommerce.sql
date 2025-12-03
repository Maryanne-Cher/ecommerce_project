{{
    config(
        unique_key='event_key'
    )
}}

WITH fact_ecommerce AS (
    SELECT *
    FROM {{ ref('silver_ecommerce') }}
),

fact AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY event_date_and_time ASC) AS event_key,
        event_date_and_time,
        event_date,
        event_time_only,
        event_type,
        product_id,
        category,
        subcategory,
        price,
        user_id,
        user_session
    FROM fact_ecommerce
)

SELECT *
FROM fact

{% if is_incremental() %}
  WHERE event_key NOT IN (SELECT event_key FROM {{ this }})
{% endif %}