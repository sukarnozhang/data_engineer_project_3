--Joining current weather forecast with 

with weather_current as(
    select
        CloudCover,
        FeelsLike,
        Humidity,
        Observation_Time,
        Precip,
        Pressure,
        Temperature,
        UV_Index,
        Visibility,
        Weather_Code,
        Wind_Degree,
        Wind_Dir,
        Wind_Speed,
        _AIRBYTE_CURRENT_HASHID 
    from {{ref('stg_weather_current')}}
)
,weather_location as(
    select
        country,
        lat,
        Lon,
        Name,
        Region,
        localtime,
        _AIRBYTE_CALIFORNIA_CURRENT_WEATHER_HASHID
    from {{ref('stg_weather_current_location')}}
)

select
    distinct c.Humidity,
    c.Pressure,
    c.Temperature,
    c.Wind_Speed,
    c.Wind_Dir,
    l.country,
    l.lat,
    l.lon,
    l.Name,
    l.Region,
    l.localtime
from weather_current as c
cross join weather_location as l