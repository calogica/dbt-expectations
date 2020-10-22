{%- macro test_table_row_count_compare(model, compare_model) -%}
{{ dbt_expectations.test_equal_expression(model, "count(*)", compare_model=compare_model) }}
{%- endmacro -%}