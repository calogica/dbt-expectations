{% macro test_expect_column_stdev_to_be_between(model, column_name,
                                                    minimum,
                                                    maximum,
                                                    partition_column=None,
                                                    partition_filter=None
                                                    ) %}

{{ dbt_expectations._test_agg_between(model, column_name=column_name, 
                                agg_func="stddev",
                                minimum=minimum, 
                                maximum=maximum, 
                                partition_column=partition_column, 
                                partition_filter=partition_filter
                                ) }}
{% endmacro %}