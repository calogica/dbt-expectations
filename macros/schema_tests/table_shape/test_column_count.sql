{%- macro test_column_count(model, expected_number_of_columns) -%}
{%- set number_actual_columns = (adapter.get_columns_in_relation(model) | length) -%}
-- {{number_actual_columns }}
select {{ (number_actual_columns - expected_number_of_columns) | abs }}
{%- endmacro -%}