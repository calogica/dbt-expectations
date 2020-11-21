{% macro test_expect_column_values_to_not_be_in_set(model, column_name,
                                                   value_set,
                                                   partition_column=None,
                                                   partition_filter=None,
                                                   quote_values=True
                                                   ) %}

with all_values as (

    select
        {{ column_name }} as value_field

    from {{ model }}
    {% if partition_column and partition_filter %}
    where {{ partition_column }} {{ partition_filter }}
    {% endif %}

),
set_values as (

    {% for value in value_set -%}
    select 
        {% if quote_values -%}
        '{{ value }}'
        {%- else -%}
        {{ value }}
        {%- endif %} as value_field
    {% if not loop.last %}union all{% endif %}
    {% endfor %}
),
validation_errors as (
    -- values from the model that match the set
    select
        v.value_field
    from 
        all_values v
        inner join
        set_values s on v.value_field = s.value_field

)

select count(*) as validation_errors
from validation_errors

{% endmacro %}
