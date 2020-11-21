{%- macro test_expect_table_column_count_to_equal(model, value) -%}
{%- set number_actual_columns = (adapter.get_columns_in_relation(model) | length) -%}
select {{ (number_actual_columns - value) | abs }}
{%- endmacro -%}