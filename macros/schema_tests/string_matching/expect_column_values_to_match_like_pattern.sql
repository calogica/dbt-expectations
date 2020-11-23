{% macro test_expect_column_values_to_match_like_pattern(model, column_name,
                                                    like_pattern,
                                                    row_condition=None
                                                    ) %}

{% set expression %}
{{ column_name }} like '{{ like_pattern }}'
{% endset %}

{{ dbt_expectations.expression_is_true(model,
                                        expression=expression,
                                        row_condition=row_condition
                                        )
                                        }}

{% endmacro %}
