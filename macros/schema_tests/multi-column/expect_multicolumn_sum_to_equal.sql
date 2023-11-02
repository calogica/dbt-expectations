
{% test expect_multicolumn_sum_to_equal(model,
                                                column_list,
                                                sum_total,
                                                group_by=None,
                                                row_condition=None
                                                ) %}

{% set expression %}
{% for column in column_list %}
sum({{ column }}){% if not loop.last %} + {% endif %}
{# the if just allows for column names or literal numbers #}
{% endfor %} = {% if sum_total is number %}{{sum_total}}{% else %}sum({{ sum_total }}){% endif %}
{% endset %}

{{ dbt_expectations.expression_is_true(model,
                                        expression=expression,
                                        group_by_columns=group_by,
                                        row_condition=row_condition
                                        )
                                        }}

{% endtest %}
