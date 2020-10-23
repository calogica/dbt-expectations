{% macro test_expect_column_value_lengths_to_be_between(model) %}
{% set column_name = kwargs.get('column_name', kwargs.get('arg')) %}
{% set minimum_length = kwargs.get('minimum_length', 0) %}
{% set maximum_length = kwargs.get('maximum_length', kwargs.get('arg')) %}
{% set partition_column = kwargs.get('partition_column', kwargs.get('arg')) %}
{% set partition_filter =  kwargs.get('partition_filter', kwargs.get('arg')) %}
select count(*)
from (

    select
        {{ column_name }}

    from {{ model }}
    where 
        (
            {{ dbt_utils.length(column_name) }} < {{ minimum_length}}
            or 
            {{ dbt_utils.length(column_name) }} > {{ maximum_length}}
        )
    {% if partition_column and partition_filter %}
        and {{ partition_column }} {{ partition_filter }}
    {% endif %}

) validation_errors
{% endmacro %}