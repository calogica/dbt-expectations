{%- macro test_expect_table_row_count_to_equal_other_table_times_factor(model, compare_model, factor) -%}
{{ dbt_expectations.test_equal_expression(model, "count(*)", compare_model=compare_model, compare_expression="count(*) * " + factor|string) }}
{%- endmacro -%}
