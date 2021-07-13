{%- test expect_table_row_count_to_equal_other_table_times_factor(model, compare_model, factor, row_condition=None, compare_row_condition=None) -%}
{{ dbt_expectations.test_expect_table_row_count_to_equal_other_table(model, compare_model,
    factor=factor,
    row_condition=row_condition,
    compare_row_condition=compare_row_condition
) }}
{%- endtest -%}
