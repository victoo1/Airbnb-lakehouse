{{ config(
    materialized='incremental',
    unique_key=['listing_id', 'metric_date']
) }}

WITH calendar AS (
    SELECT * FROM {{ ref('stg_calendar') }}
)

SELECT
    listing_id,
    calendar_date AS metric_date,
    daily_price,
    CASE WHEN is_booked THEN 1 ELSE 0 END AS occupied_count,
    CASE WHEN is_booked THEN daily_price ELSE 0 END AS realized_revenue,
    CURRENT_TIMESTAMP() AS dbt_updated_at
FROM calendar

{% if is_incremental() %}
  WHERE calendar_date >= (SELECT MAX(metric_date) FROM {{ this }})
{% endif %}