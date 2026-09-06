{{ config(materialized='view') }}

WITH raw_calendar AS (
    SELECT 
        listing_id,
        calendar_date,
        available_flag,
        listing_price
    FROM {{ source('bronze_raw', 'RAW_CALENDAR') }}
)

SELECT
    listing_id,
    calendar_date,
    CASE WHEN available_flag = 'f' THEN TRUE ELSE FALSE END AS is_booked,
    COALESCE(listing_price, 0) AS daily_price
FROM raw_calendar
WHERE listing_id IS NOT NULL AND calendar_date IS NOT NULL
