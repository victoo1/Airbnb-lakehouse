{{ config(materialized='view') }}

WITH raw_listings AS (
    SELECT 
        $1:id::BIGINT AS listing_id,
        $1:name::STRING AS property_name,
        $1:neighbourhood_cleansed::STRING AS neighborhood,
        $1:latitude::FLOAT AS latitude,
        $1:longitude::FLOAT AS longitude,
        $1:property_type::STRING AS property_type,
        $1:room_type::STRING AS room_type,
        $1:accommodates::INT AS max_guests,
        $1:amenities::STRING AS raw_amenities
    FROM @GREYSTAR_PROPTECH_DB.PUBLIC.S3_RAW_STAGE/listings/
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