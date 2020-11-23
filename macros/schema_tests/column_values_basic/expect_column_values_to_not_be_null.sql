{% macro test_expect_column_values_to_not_be_null(model, column_name, row_condition=None) %}

{% set expression = column_name ~ " is not null" %}

{{ dbt_expectations.expression_is_true(model,
                                        expression=expression,
                                        row_condition=row_condition
                                        )
                                        }}
{% endmacro %}
