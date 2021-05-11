{%- macro test_expect_table_column_count_to_be_between(model, min_value, max_value) -%}
{%- if execute -%}
{%- set number_actual_columns = (adapter.get_columns_in_relation(model) | length) -%}
select
    1
from (select 1) a
where
    {{ number_actual_columns }} < {{ min_value }}
    or
    {{ number_actual_columns }} > {{ max_value }}
{%- endif -%}
{%- endmacro -%}
