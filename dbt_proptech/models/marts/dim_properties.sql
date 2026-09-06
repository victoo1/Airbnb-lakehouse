{{ config(materialized='table') }}

WITH stg_listings AS (
    SELECT * FROM {{ ref('stg_listings') }}
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
    amenities_json,
    CURRENT_TIMESTAMP() AS updated_at
FROM stg_listings





























