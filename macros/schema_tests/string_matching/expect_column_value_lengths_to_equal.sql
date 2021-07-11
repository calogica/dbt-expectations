{% test expect_column_value_lengths_to_equal(model, column_name,
                                                    value,
                                                    row_condition=None
                                                    ) %}

{% set expression = dbt_utils.length(column_name) ~ " = " ~ value %}

{{ dbt_expectations.expression_is_true(model,
                                        expression=expression,
                                        group_by_columns=group_by,
                                        row_condition=row_condition
                                        )
                                        }}

{% endtest %}
