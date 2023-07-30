-- Average Forecast and Current Updates for a city.
with weather_current_forecast as (
    select
        current_humidity,
        current_pressure,
        current_temperature,
        current_wind_speed,
        current_wind_direction,
        country,
        forecasted_humidity,
        forecasted_pressure,
        forecasted_temperature,
        forecasted_wind_speed,
        forecasted_wind_direction
    from
        {{ref('cal_weather_current_forecast_location')}}
)

select
    avg(current_humidity) as average_current_humidity,
    avg(forecasted_humidity) as average_forecast_humidity,
    avg(current_temperature) as average_current_temperature,
    avg(forecasted_temperature) as average_forecasted_temperature,
    avg(current_pressure) as average_current_pressure,
    avg(forecasted_pressure) as average_forecasted_pressure,
    avg(current_wind_speed) as average_current_wind_speed,
    avg(forecasted_wind_speed) as average_forecasted_wind_speed
from
    weather_current_forecast
limit 50
