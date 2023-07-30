{{
    config(
            materialized = "table",
            database = "AIRBYTE_DATABASE",
            schema = "AIRBYTE_SCHEMA"
    )
 }}

select
    country,
    lat,
    lon,
    name,
    region,
    _airbyte_california_current_weather_hashid
from
    {{ source("AIRBYTE_SCHEMA","CALIFORNIA_CURRENT_WEATHER_LOCATION") }}
