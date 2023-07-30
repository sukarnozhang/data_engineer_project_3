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
    min(cloudcover) as min_cloudcover,
    min(precipitation) as min_precipitation,
    min(pressure) as min_pressure,
    min(temperature) as min_temperature,
    min(wind_speed) as min_wind_speed,
    min(feelslike) as min_feelslike,
    min(humidity) as min_humidity,
    min(visibility) as min_visibility,
    min(weather_code) as min_weather_code,
    max(observation_time) as last_observation_time
from current_weather
