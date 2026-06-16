{% macro decode_status(column_name) %}
    case {{ column_name }}
        when 0 then 'Disabled'
        when 2 then 'Active'
        else 'Unknown'
    end
{% endmacro %}