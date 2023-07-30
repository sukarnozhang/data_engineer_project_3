with weather_current as (
    select
        cloudcover,
        feelslike,
        humidity,
        observation_time,
        precip,
        pressure,
        temperature,
        uv_index,
        visibility,
        weather_code,
        wind_degree,
        wind_dir,
        wind_speed,
        _airbyte_current_hashid
    from {{ref('stg_weather_current')}}
),

weather_location as (
    select
        country,
        lat,
        lon,
        name,
        region,
        _airbyte_california_current_weather_hashid
    from {{ref('stg_weather_current_location')}}
),

final as (
    select
        {{ dbt_utils.surrogate_key(['weather_current._AIRBYTE_CURRENT_HASHID']) }} as weather_key,
        {{ dbt_utils.surrogate_key(['_AIRBYTE_CALIFORNIA_CURRENT_WEATHER_HASHID']) }} as weather_location_key,
        weather_current.cloudcover,
        weather_current.feelslike,
        weather_current.pressure,
        weather_current.uv_index,
        weather_current.wind_degree,
        weather_current.wind_dir,
        weather_current.wind_speed,
        country,
        lat,
        lon,
        name,
        region
    from weather_current
    cross join weather_location
)

select *
from final
