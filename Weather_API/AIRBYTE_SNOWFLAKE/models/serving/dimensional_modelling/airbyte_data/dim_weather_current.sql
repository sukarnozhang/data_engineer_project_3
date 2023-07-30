with stg_weather_current as (
    select * from {{ref('stg_weather_current')}}
),

transformed as (
    select
        {{ dbt_utils.surrogate_key(['stg_weather_current._AIRBYTE_CURRENT_HASHID']) }} as weather_current_key,
        *
    from stg_weather_current
)

select *
from transformed
