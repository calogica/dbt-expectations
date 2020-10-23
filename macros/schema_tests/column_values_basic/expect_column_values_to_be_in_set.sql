{% macro test_expect_column_values_to_be_in_set(model, values) %}

{% set column_name = kwargs.get('column_name', kwargs.get('field')) %}
{% set quote_values = kwargs.get('quote', True) %}
{% set partition_column = kwargs.get('partition_column', kwargs.get('arg')) %}
{% set partition_filter =  kwargs.get('partition_filter', kwargs.get('arg')) %}

with all_values as (

    select
        {{ column_name }} as value_field

    from {{ model }}
    {% if partition_column and partition_filter %}
    where {{ partition_column }} {{ partition_filter }}
    {% endif %}

),
set_values as (

    {% for value in values -%}
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
    -- values from the model that are not in the set
    select
        v.value_field
    from 
        all_values v
        left outer join
        set_values s on v.value_field = s.value_field
    where
        v.value_field is null

)

select count(*) as validation_errors
from validation_errors

{% endmacro %}
