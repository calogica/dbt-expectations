
{% macro test_expect_column_pair_values_A_to_be_greater_than_B(model,
                                                                column_A,
                                                                column_B,
                                                                or_equal=False,
                                                                partition_column=None,
                                                                partition_filter=None
                                                                ) %}

{% set operator = ">=" if or_equal else ">" %}

{% set filter_cond = partition_column ~ " " ~ partition_filter if partition_column and partition_filter else None %}
{% set expression = column_A ~ " " ~ operator ~ " " ~ column_B %}

{{ dbt_expectations.expression_is_true(model,
                                        expression=expression,
                                        filter_cond=filter_cond
                                        )
                                        }}

{% endmacro %}
