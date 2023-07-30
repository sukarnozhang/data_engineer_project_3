with weather_code as (
    select
        weathercode as weather_code,
        condition as weather_condition
    from
        {{ref('weather_codes')}}
),

min_weather as (
    select
        min_cloudcover,
        min_precipitation,
        min_pressure,
        min_temperature,
        min_wind_speed,
        min_feelslike,
        min_humidity,
        min_visibility,
        min_weather_code
    from
        {{ref('jakarta_kafka_min')}}
)

select
    min_cloudcover,
    min_precipitation,
    min_pressure,
    min_temperature,
    min_wind_speed,
    min_feelslike,
    min_humidity,
    min_visibility,
    weather_code.weather_code,
    weather_code.weather_condition
from
    min_weather
inner join weather_code
    on min_weather.min_weather_code = weather_code.weather_code
