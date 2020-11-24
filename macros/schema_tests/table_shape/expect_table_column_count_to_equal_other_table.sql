{%- macro test_expect_table_column_count_to_equal_other_table(model, compare_model) -%}
{%- if execute -%}
{%- set number_columns = (adapter.get_columns_in_relation(model) | length) -%}
{%- set compare_number_columns = (adapter.get_columns_in_relation(compare_model) | length) -%}
select {{ (number_columns - compare_number_columns) | abs }}
{%- endif -%}
{%- endmacro -%}
