select distinct
    record_content:current:cloudcover as cloudcover,
    record_content:current:precip as precipitation,
    record_content:current:observation_time as observation_time,
    record_content:current:pressure as pressure,
    record_content:current:temperature as temperature,
    record_content:current:weather_descriptions as weather_descriptions,
    record_content:current:wind_degree as wind_degree,
    record_content:current:wind_dir as wind_direction,
    record_content:current:wind_speed as wind_speed,
    record_content:current:feelslike as feelslike,
    record_content:current:humidity as humidity,
    record_content:current:visibility as visibility,
    record_content:current:weather_code as weather_code
from {{ source('AIRBYTE_SCHEMA','TOPIC1') }}
