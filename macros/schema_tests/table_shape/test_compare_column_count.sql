{%- macro test_compare_column_count(model, compare_model) -%}
{%- set number_columns = (adapter.get_columns_in_relation(model) | length) -%}
{%- set compare_number_columns = (adapter.get_columns_in_relation(compare_model) | length) -%}
select {{ (number_columns - compare_number_columns) | abs }}
{%- endmacro -%}