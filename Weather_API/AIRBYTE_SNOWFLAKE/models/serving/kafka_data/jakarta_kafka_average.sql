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
    avg(cloudcover) as average_cloudcover,
    avg(precipitation) as average_precipitation,
    avg(pressure) as average_pressure,
    avg(temperature) as average_temperature,
    avg(wind_speed) as average_wind_speed,
    avg(feelslike) as average_feelslike,
    avg(humidity) as average_humidity,
    avg(visibility) as average_visibility,
    avg(weather_code) as average_weather_code,
    max(observation_time) as last_observation_time
from current_weather
