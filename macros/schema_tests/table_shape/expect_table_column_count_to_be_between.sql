{%- macro test_expect_table_column_count_to_be_between(model, min_value, max_value) -%}
{%- set number_actual_columns = (adapter.get_columns_in_relation(model) | length) -%}
select
    case
        when {{ number_actual_columns >= min_value and number_actual_columns <= max_value }}
        then 0 else 1
    end
{%- endmacro -%}
