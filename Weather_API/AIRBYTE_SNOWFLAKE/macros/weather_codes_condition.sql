{% macro weather_codes_condition(Weather_Code) %}
(
    select 
        Condition
    from
        {{ref('weather_codes')}}
    where
        WeatherCode={{Weather_Code}}
)
{% endmacro %}