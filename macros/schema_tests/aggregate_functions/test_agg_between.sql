{% macro test_agg_between(model) %}
{% set column_name = kwargs.get('column_name', kwargs.get('arg')) %}
{% set agg_func = kwargs.get('agg_func', 0) %}
{% set minimum = kwargs.get('minimum', 0) %}
{% set maximum = kwargs.get('maximum', kwargs.get('arg')) %}
{% set partition_column = kwargs.get('partition_column', kwargs.get('arg')) %}
{% set partition_filter =  kwargs.get('partition_filter', kwargs.get('arg')) %}
with column_aggregate as (
 
    select
        {{ agg_func }}({{ column_name }}) as column_val
    from 
        {{ model }}
    {% if partition_column and partition_filter %}
    where {{ partition_column }} {{ partition_filter }}
    {% endif %}

)
select count(*)
from (

    select
        column_val
    from 
        column_aggregate
    where 
        (
            column_val < {{ minimum }}
            or 
            column_val > {{ maximum }}
        )
 
    ) validation_errors
{% endmacro %}