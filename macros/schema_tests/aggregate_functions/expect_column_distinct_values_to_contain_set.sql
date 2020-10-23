{% macro test_expect_column_distinct_values_to_contain_set(model, values) %}

{% set column_name = kwargs.get('column_name', kwargs.get('field')) %}
{% set quote_values = kwargs.get('quote', True) %}
{% set partition_column = kwargs.get('partition_column', kwargs.get('arg')) %}
{% set partition_filter =  kwargs.get('partition_filter', kwargs.get('arg')) %}

with all_values as (

    select distinct
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
unique_set_values as (

    select distinct value_field
    from
        set_values

),
validation_errors as (
    -- values in set that are not in the list of values from the model
    select
        s.value_field
    from 
        unique_set_values s
        left outer join
        all_values v on s.value_field = v.value_field
    where
        v.value_field is null

)

select count(*) as validation_errors
from validation_errors

{% endmacro %}
