{{ config(materialized='view') }}

WITH raw_listings AS (
    SELECT 
        listing_id,
        property_name,
        neighborhood,
        latitude,
        longitude,
        property_type,
        room_type,
        max_guests,
        raw_amenities
    FROM {{ source('bronze_raw', 'RAW_LISTINGS') }}
)

SELECT
    listing_id,
    property_name,
    neighborhood,
    latitude,
    longitude,
    property_type,
    room_type,
    max_guests,
    PARSE_JSON(raw_amenities) AS amenities_json
FROM raw_listings
WHERE listing_id IS NOT NULL
