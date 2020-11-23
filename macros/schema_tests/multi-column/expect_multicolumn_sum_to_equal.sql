
{% macro test_expect_multicolumn_sum_to_equal(model,
                                                column_list,
                                                sum_total,
                                                row_condition=None
                                                ) %}

{% set operator = "=" %}
{% set expression %}
{% for column in column_list %}
sum({{ column }}){% if not loop.last %} + {% endif %}
{% endfor %} = {{ sum_total }}
{% endset %}

{{ dbt_expectations.expression_is_true(model,
                                        expression=expression,
                                        row_condition=row_condition
                                        )
                                        }}

{% endmacro %}
