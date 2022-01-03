{%- test expect_table_row_count_to_equal_other_table(model, compare_model, factor=1, row_condition=None, compare_row_condition=None) -%}
{{ dbt_expectations.test_equal_expression(model, "count(*)",
    compare_model=compare_model,
    compare_expression="count(*) * " + factor|string,
    row_condition=row_condition,
    compare_row_condition=compare_row_condition
) }}
{%- endtest -%}
