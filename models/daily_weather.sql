{{ config(materialized='table') }}

WITH daily_weather AS (

    SELECT
        DATE(time) AS daily_weather,
        weather,
        temp,
        pressure,
        humidity,
        clouds
    FROM {{ source('demo', 'weather') }}

),

daily_weather_agg AS (

    SELECT
        daily_weather,
        weather,
        ROUND(AVG(temp), 2) AS avg_temp,
        ROUND(AVG(pressure), 2) AS avg_pressure,
        ROUND(AVG(humidity), 2) AS avg_humidity,
        ROUND(AVG(clouds), 2) AS avg_clouds,
        COUNT(weather) AS weather_count

    FROM daily_weather

    GROUP BY daily_weather, weather

),

daily_weather_ranked AS (

    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY daily_weather
            ORDER BY weather_count DESC
        ) AS weather_rank

    FROM daily_weather_agg

)

SELECT
    *
FROM daily_weather_ranked
WHERE daily_weather = '2016-11-07'