{{ config(materialized='table') }}

SELECT 
    listing_id,
    property_name,
    neighborhood,
    property_type,
    room_type,
    max_guests,
    ARRAY_CONTAINS('Wifi'::VARIANT, amenities_json) AS has_wifi,
    ARRAY_CONTAINS('Air conditioning'::VARIANT, amenities_json) AS has_ac
FROM {{ ref('stg_listings') }}