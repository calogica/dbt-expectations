{% macro test_expect_column_unique_value_count_to_be_between(model) %}
{% set column_name = kwargs.get('column_name', kwargs.get('arg')) %}
{% set minimum = kwargs.get('minimum', 0) %}
{% set maximum = kwargs.get('maximum', kwargs.get('arg')) %}
{% set partition_column = kwargs.get('partition_column', kwargs.get('arg')) %}
{% set partition_filter =  kwargs.get('partition_filter', kwargs.get('arg')) %}
with column_aggregate as (
 
    select
        count(distinct {{ column_name }}) as value_count
    from 
        {{ model }}
    {% if partition_column and partition_filter %}
    where {{ partition_column }} {{ partition_filter }}
    {% endif %}

)
select count(*)
from (

    select
        value_count
    from 
        column_aggregate
    where 
        (
            value_count < {{ minimum }}
            or 
            value_count > {{ maximum }}
        )
 
    ) validation_errors
{% endmacro %}