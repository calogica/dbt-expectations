
{% macro test_expect_column_pair_values_to_be_equal(model, 
                                                        column_A, 
                                                        column_B,
                                                        partition_column=None,
                                                        partition_filter=None
                                                        ) %}

{% set operator = "=" %}
{% set filter_cond = partition_column ~ " " ~ partition_filter if partition_column and partition_filter else None %}
{% set expression = column_A ~ " " ~ operator ~ " " ~ column_B %}

{{ dbt_expectations.expression_is_true(model, 
                                        expression=expression,
                                        filter_cond=filter_cond
                                        )
                                        }}

{% endmacro %}