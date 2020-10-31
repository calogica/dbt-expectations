{% macro test_expect_column_value_lengths_to_equal(model, column_name,
                                                    length,
                                                    partition_column=None,
                                                    partition_filter=None
                                                    ) %}

{% set filter_cond = partition_column ~ " " ~ partition_filter if partition_column and partition_filter else None %}
{% set expression = dbt_utils.length(column_name) ~ " = " ~ length %}

{{ dbt_expectations.expression_is_true(model, 
                                        expression=expression,
                                        filter_cond=filter_cond
                                        )
                                        }}

{% endmacro %}