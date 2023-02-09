{% test expect_column_null_percentage_to_be_less_than(model,
                                                       column_name,
                                                       value,
                                                       group_by=None,
                                                       row_condition=None
                                                       ) %}
{% set expression %}
( count(*) - count( {{ column_name }} ) ) * 1.0 / count(*)  < {{ value }} 
{% endset %}
{{ dbt_expectations.expression_is_true(model,
                                        expression=expression,
                                        group_by_columns=group_by,
                                        row_condition=row_condition)
                                        }}
{%- endtest -%}