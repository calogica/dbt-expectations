{% macro test_expect_column_values_to_be_unique(model) %}
{% set column_name = kwargs.get('column_name', kwargs.get('arg')) %}
{% set partition_column = kwargs.get('partition_column', kwargs.get('arg')) %}
{% set partition_filter =  kwargs.get('partition_filter', kwargs.get('arg')) %}
select count(*)
from (

    select
        {{ column_name }}

    from {{ model }}
    where {{ column_name }} is not null
    {% if partition_column and partition_filter %}
        and {{ partition_column }} {{ partition_filter }}
    {% endif %}
    group by {{ column_name }}
    having count(*) > 1

) validation_errors
{% endmacro %}