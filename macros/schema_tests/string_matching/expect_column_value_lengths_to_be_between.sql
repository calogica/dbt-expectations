{% macro test_expect_column_value_lengths_to_be_between(model, column_name,
                                                         min_value,
                                                         max_value,
                                                         row_condition=None
                                                      ) %}
{% set expression %}
{{ dbt_utils.length(column_name) ~ " >= " ~ min_value ~ " or " ~
   dbt_utils.length(column_name) ~ " <= " ~ max_value }}
{% endset %}

{{ dbt_expectations.expression_is_true(model,
                                        expression=expression,
                                        row_condition=row_condition
                                        )
                                        }}


{% endmacro %}
