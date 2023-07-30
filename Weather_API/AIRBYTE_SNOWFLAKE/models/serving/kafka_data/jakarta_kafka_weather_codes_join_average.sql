with weather_code as (
    select
        weathercode as weather_code,
        condition as weather_condition
    from
        {{ref('weather_codes')}}
),

avg_weather as (
    select
        average_cloudcover,
        average_precipitation,
        average_pressure,
        average_temperature,
        average_wind_speed,
        average_feelslike,
        average_humidity,
        average_visibility,
        average_weather_code
    from
        {{ref('jakarta_kafka_average')}}
)

select
    average_cloudcover,
    average_precipitation,
    average_pressure,
    average_temperature,
    average_wind_speed,
    average_feelslike,
    average_humidity,
    average_visibility,
    weather_code.weather_code,
    weather_code.weather_condition
from
    avg_weather
inner join weather_code
    on avg_weather.average_weather_code = weather_code.weather_code

