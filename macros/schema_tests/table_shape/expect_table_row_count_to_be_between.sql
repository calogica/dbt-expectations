{%- macro test_expect_table_row_count_to_be_between(model) -%}
{% set minimum = kwargs.get('minimum', 0) %}
{% set maximum = kwargs.get('maximum', kwargs.get('arg')) %}
{% set partition_column = kwargs.get('partition_column', kwargs.get('arg')) %}
{% set partition_filter =  kwargs.get('partition_filter', kwargs.get('arg')) %}
with row_count as (
    select count(*) as cnt 
    from {{ model }}
    {% if partition_column and partition_filter %}
    where {{ partition_column }} {{ partition_filter }}
    {% endif %}
)
select count(*)
from 
    row_count
where cnt < {{ minimum }} or
      cnt > {{ maximum }}
{%- endmacro -%}