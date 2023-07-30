{% macro weather_current_forecast_correlation(current_parameter,forecast_parameter) %}
    case
            when {{ current_parameter}} - {{ forecast_parameter }} = 0 then correct_prediction
            else wrong_prediction
        end
{% endmacro %}
