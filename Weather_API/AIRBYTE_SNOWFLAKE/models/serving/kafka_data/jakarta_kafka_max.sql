with current_weather as (
    select
        cloudcover,
        precipitation,
        pressure,
        temperature,
        wind_speed,
        feelslike,
        humidity,
        visibility,
        weather_code,
        observation_time
    from
        {{ref('stg_jakarta_kafka_alias')}}
)

select
    max(cloudcover) as max_cloudcover,
    max(precipitation) as max_precipitation,
    max(pressure) as max_pressure,
    max(temperature) as max_temperature,
    max(wind_speed) as max_wind_speed,
    max(feelslike) as max_feelslike,
    max(humidity) as max_humidity,
    max(visibility) as max_visibility,
    max(weather_code) as max_weather_code,
    max(observation_time) as last_observation_time
from current_weather
