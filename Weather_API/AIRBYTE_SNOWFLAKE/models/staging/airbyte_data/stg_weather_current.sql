{{
    config(
            materialized = "table",
            database = "AIRBYTE_DATABASE",
            schema = "AIRBYTE_SCHEMA"
    )
 }}

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
from
    {{ source("AIRBYTE_SCHEMA","CALIFORNIA_CURRENT_WEATHER_CURRENT") }}
