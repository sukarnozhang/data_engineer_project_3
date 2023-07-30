with weather_current_location as(
    select
        Humidity,
        Pressure,
        Temperature,
        Wind_Speed,
        Wind_Dir,
        country,
        lat,
        lon,
        localtime
    from
        {{ref('cal_weather_location_current_status')}}
)
,weather_forecast_location as(
    select
        Humidity,
        Pressure,
        Temperature,
        Wind_Speed,
        Wind_Dir,
        Country
    from
        {{ref('cal_weather_forecast_location_status')}}
)

select
    distinct c.Humidity as Current_Humidity,
    c.Pressure as Current_Pressure,
    c.Temperature as Current_Temperature,
    c.Wind_Speed as Current_Wind_Speed,
    c.Wind_Dir as Current_Wind_Direction,
    c.Country as Country,
    f.Humidity as Forecasted_Humidity,
    f.Pressure as Forecasted_Pressure,
    f.Temperature as Forecasted_Temperature,
    f.Wind_Speed as Forecasted_Wind_Speed,
    f.Wind_Dir as Forecasted_Wind_Direction,
    c.localtime
from
    weather_current_location as c
    inner join weather_forecast_location as f
    on c.Country=f.Country
    limit 50
