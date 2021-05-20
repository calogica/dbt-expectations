{%- macro test_expect_table_row_count_to_equal(model, value, row_condition) -%}
    {{ adapter.dispatch('test_expect_table_row_count_to_equal', packages=dbt_expectations._get_namespaces()) (model, value, row_condition) }}
{% endmacro %}



{%- macro default__test_expect_table_row_count_to_equal(model,
                                                value,
                                                row_condition=None
                                                ) -%}
{% set expression %}
count(*) = {{ value }}
{% endset %}
{{ dbt_expectations.expression_is_true(model,
                                        expression=expression,
                                        row_condition=row_condition)
                                        }}
{%- endmacro -%}
