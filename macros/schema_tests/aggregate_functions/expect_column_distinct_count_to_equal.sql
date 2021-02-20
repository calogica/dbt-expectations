{% macro test_expect_column_distinct_count_to_equal(model,
                                                    column_name,
                                                    value,
                                                    quote_values=False,
                                                    row_condition=None
                                                    ) %}
{% set expression %}
count(distinct {{ column_name }}) = {{ value }}
{% endset %}
{{ dbt_expectations.expression_is_true(model,
                                        expression=expression,
                                        row_condition=row_condition)
                                        }}
{%- endmacro -%}
