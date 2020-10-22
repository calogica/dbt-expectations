{% macro test_length_equal(model) %}
{% set column_name = kwargs.get('column_name', kwargs.get('arg')) %}
{% set length = kwargs.get('length', 0) %}
{% set partition_column = kwargs.get('partition_column', kwargs.get('arg')) %}
{% set partition_filter =  kwargs.get('partition_filter', kwargs.get('arg')) %}
select count(*)
from (

    select
        {{ column_name }}

    from {{ model }}
    where 
        {{ dbt_utils.length(column_name) }} != {{ length}}
    {% if partition_column and partition_filter %}
        and {{ partition_column }} {{ partition_filter }}
    {% endif %}

) validation_errors
{% endmacro %}