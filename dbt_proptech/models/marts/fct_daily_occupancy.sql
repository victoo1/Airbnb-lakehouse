{{ config(materialized='incremental', unique_key=['listing_id', 'calendar_date']) }}

WITH stg_calendar AS (
    SELECT * FROM {{ ref('stg_calendar') }}
)

SELECT
    listing_id,
    calendar_date,
    is_booked,
    daily_price,
    CURRENT_TIMESTAMP() AS updated_at
FROM stg_calendar

{% if is_incremental() %}
    WHERE calendar_date >= (SELECT MAX(calendar_date) FROM {{ this }})
{% endif %}