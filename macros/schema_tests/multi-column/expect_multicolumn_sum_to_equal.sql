
{% macro test_expect_multicolumn_sum_to_equal(model, 
                                                column_list,
                                                sum_total,
                                                partition_column=None,
                                                partition_filter=None
                                                ) %}

{% set operator = "=" %}
{% set filter_cond = partition_column ~ " " ~ partition_filter if partition_column and partition_filter else None %}
{% set expression %}
{% for column in column_list %}
sum({{ column }}){% if not loop.last %} + {% endif %}
{% endfor %} = {{ sum_total }}
{% endset %}

{{ dbt_expectations.expression_is_true(model, 
                                        expression=expression,
                                        filter_cond=filter_cond
                                        )
                                        }}

{% endmacro %}