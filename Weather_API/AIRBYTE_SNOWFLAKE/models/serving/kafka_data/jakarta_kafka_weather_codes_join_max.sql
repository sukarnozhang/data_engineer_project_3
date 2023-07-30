with weather_code as (
    select
        weathercode as weather_code,
        condition as weather_condition
    from
        {{ref('weather_codes')}}
),

max_weather as (
    select
        max_cloudcover,
        max_precipitation,
        max_pressure,
        max_temperature,
        max_wind_speed,
        max_feelslike,
        max_humidity,
        max_visibility,
        max_weather_code
    from
        {{ref('jakarta_kafka_max')}}
)

select
    max_cloudcover,
    max_precipitation,
    max_pressure,
    max_temperature,
    max_wind_speed,
    max_feelslike,
    max_humidity,
    max_visibility,
    weather_code.weather_code,
    weather_code.weather_condition
from
    max_weather
inner join weather_code
    on max_weather.max_weather_code = weather_code.weather_code
