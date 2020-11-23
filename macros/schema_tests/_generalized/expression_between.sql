{% macro test_expression_between(model,
                                 expression,
                                 min_value,
                                 max_value,
                                 row_condition=None
                                 ) %}

    {{ dbt_expectations.expression_between(model, expression, min_value, max_value, row_condition) }}

{% endmacro %}

{% macro expression_between(model,
                            expression,
                            min_value,
                            max_value,
                            row_condition
                            ) %}

{% set expression %}
{{ expression }} >= {{ min_value }} and
{{ expression }} <= {{ max_value }}
{% endset %}

{{ dbt_expectations.expression_is_true(model,
                                        expression=expression,
                                        row_condition=row_condition)
                                        }}

{% endmacro %}
