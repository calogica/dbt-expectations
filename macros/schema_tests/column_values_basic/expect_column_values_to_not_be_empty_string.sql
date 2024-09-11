{% test expect_column_values_to_not_be_null(model, column_name, trim=False, row_condition=None) %}

{% if trim %}
    {% set expression = trim(column_name) ~ " != '' " %}
{% else %}
    {% set expression = column_name ~ " != '' " %}
{% end if %}

{{ dbt_expectations.expression_is_true(model,
                                        expression=expression,
                                        group_by_columns=None,
                                        row_condition=row_condition
                                        )
                                        }}
{% endtest %}
