{%- macro test_expect_table_row_count_to_equal_other_table(model, compare_model) -%}
{{ dbt_expectations.test_equal_expression(model, "count(*)", compare_model=compare_model, return_difference=True) }}
{%- endmacro -%}
