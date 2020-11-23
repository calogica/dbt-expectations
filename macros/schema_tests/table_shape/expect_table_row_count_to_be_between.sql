{%- macro test_expect_table_row_count_to_be_between(model,
                                                      min_value,
                                                      max_value,
                                                      row_condition=None
                                                    ) -%}
{% set expression %}
count(*)
{% endset %}
{{ dbt_expectations.expression_between(model,
                                        expression=expression,
                                        min_value=min_value,
                                        max_value=max_value,
                                        row_condition=row_condition
                                        ) }}
{%- endmacro -%}
