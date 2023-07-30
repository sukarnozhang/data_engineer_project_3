--Singular test based cloud cover greater than 0 with severity "error".

{{
    config(
        severity = 'error'
    )
}}
select
    MIN_CLOUDCOVER,
    MIN_PRECIPITATION,
    MIN_PRESSURE,
    MIN_TEMPERATURE,
    MIN_WIND_SPEED,
    MIN_FEELSLIKE,
    MIN_HUMIDITY,
    MIN_VISIBILITY
from
    {{ ref('jakarta_kafka_weather_codes_join_min') }}
where
    MIN_CLOUDCOVER > 0
