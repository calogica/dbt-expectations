{% macro test_expect_column_unique_value_count_to_be_between(model, column_name,
                                                            min_value=None,
                                                            max_value=None,
                                                            row_condition=None
                                                            ) %}
{% set expression %}
count(distinct {{ column_name }})
{% endset %}
{{ dbt_expectations.expression_between(model,
                                        expression=expression,
                                        min_value=min_value,
                                        max_value=max_value,
                                        row_condition=row_condition
                                        ) }}
{% endmacro %}
