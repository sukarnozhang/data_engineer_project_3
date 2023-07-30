with stg_jakarta_kafka_alias as (
    select * from {{ref('stg_jakarta_kafka_alias')}}
),

transformed as (
    select
        {{ dbt_utils.surrogate_key(['stg_jakarta_kafka_alias.Weather_Code']) }} as weather_key,
        *
    from stg_jakarta_kafka_alias
)

select *
from transformed
