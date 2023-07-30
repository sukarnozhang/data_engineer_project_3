with weather_forecast as (
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
    from {{ref('stg_weather_forecast_current')}}
),

w_code as (
    select
        weathercode,
        condition
    from {{ref('weather_codes')}}

)

select distinct
    cloudcover,
    feelslike,
    humidity,
    observation_time,
    precip,
    pressure,
    temperature,
    uv_index,
    visibility,
    wind_degree,
    wind_dir,
    wind_speed,
    weather_code,
    _airbyte_current_hashid,
    w_code.condition
from
    weather_forecast
inner join w_code
    on weather_forecast.weather_code = w_code.weathercode
