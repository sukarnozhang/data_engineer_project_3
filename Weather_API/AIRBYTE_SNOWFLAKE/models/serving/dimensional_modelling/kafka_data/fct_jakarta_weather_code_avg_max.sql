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
        max_weather_code,
        last_observation_time
    from {{ref('jakarta_kafka_max')}}
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
        max_weather.max_cloudcover,
        max_weather.max_precipitation,
        max_weather.max_pressure,
        max_weather.max_temperature,
        max_weather. Max_Wind_Speed,
        max_weather.max_feelslike,
        max_weather.max_humidity,
        max_weather.max_visibility,
        max_weather.max_weather_code,
        avg_weather.average_cloudcover,
        avg_weather.average_precipitation,
        avg_weather.average_pressure,
        avg_weather.average_temperature,
        avg_weather.average_wind_speed,
        avg_weather.average_feelslike,
        avg_weather.average_humidity,
        avg_weather.average_visibility,
        avg_weather.average_weather_code
    from max_weather
    cross join avg_weather
)

select *
from final

{% if is_incremental() %}
    where Last_Observation_Time > (select max(Last_Observation_Time) from {{ this }})
{% endif %}
