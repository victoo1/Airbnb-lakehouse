{{ config(materialized='view') }}

WITH raw_calendar AS (
    SELECT 
        $1:listing_id::BIGINT AS listing_id,
        $1:date::DATE AS calendar_date,
        $1:available::STRING AS available_flag,
        $1:price::FLOAT AS listing_price
    FROM @GREYSTAR_PROPTECH_DB.PUBLIC.S3_RAW_STAGE/calendar/
)

SELECT
    listing_id,
    calendar_date,
    CASE WHEN available_flag = 'f' THEN TRUE ELSE FALSE END AS is_booked,
    COALESCE(listing_price, 0) AS daily_price
FROM raw_calendar
WHERE listing_id IS NOT NULL AND calendar_date IS NOT NULL