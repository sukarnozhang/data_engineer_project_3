with weather_current_forecast as(
    select
        Current_Humidity,
        Current_Pressure,
        Current_Temperature,
        Current_Wind_Speed,
        Country,
        Forecasted_Humidity,
        Forecasted_Pressure,
        Forecasted_Temperature,
        Forecasted_Wind_Speed,
        localtime
    from
        {{ref('cal_weather_current_forecast_location')}}
)

select
    distinct (Current_Humidity-Forecasted_Humidity) as Difference_Humidity,
    (Current_Pressure-Forecasted_Pressure) as Difference_Pressure,
    (Current_Temperature-Forecasted_Temperature) as Difference_Temperature,
    (Current_Wind_Speed-Forecasted_Wind_Speed) as Difference_Wind_Speed,
    localtime as localtime
from
    weather_current_forecast
    limit 50
