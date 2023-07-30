with avg_weather as (
    select
        average_cloudcover,
        average_precipitation,
        average_pressure,
        average_temperature,
        average_wind_speed,
        average_feelslike,
        average_humidity,
        average_visibility,
        average_weather_code,
        last_observation_time
    from {{ref('jakarta_kafka_average')}}
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
        min_weather_code,
        last_observation_time
    from {{ref('jakarta_kafka_min')}}
),

final as (
    select
        {{ dbt_utils.surrogate_key(['avg_weather.Average_CloudCover']) }} as weather_key,
        avg_weather.average_cloudcover,
        avg_weather.average_precipitation,
        avg_weather.average_pressure,
        avg_weather.average_temperature,
        avg_weather.average_wind_speed,
        avg_weather.average_feelslike,
        avg_weather.average_humidity,
        avg_weather.average_visibility,
        avg_weather.average_weather_code,
        min_weather.min_cloudcover,
        min_weather.min_precipitation,
        min_weather.min_pressure,
        min_weather.min_temperature,
        min_weather.min_wind_speed,
        min_weather.min_feelslike,
        min_weather.min_humidity,
        min_weather.min_visibility,
        min_weather.min_weather_code
    from
        min_weather
    cross join
        avg_weather
)

select * from final
