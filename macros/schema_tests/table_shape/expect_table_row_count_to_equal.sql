{%- macro test_expect_table_row_count_to_equal(model, expected_number_of_rows) -%}
{% set partition_column = kwargs.get('partition_column', kwargs.get('arg')) %}
{% set partition_filter =  kwargs.get('partition_filter', kwargs.get('arg')) %}
select abs({{ expected_number_of_rows }} - count(*)) 
from {{ model }}
{% if partition_column and partition_filter %}
where {{ partition_column }} {{ partition_filter }}
{% endif %}
{%- endmacro -%}