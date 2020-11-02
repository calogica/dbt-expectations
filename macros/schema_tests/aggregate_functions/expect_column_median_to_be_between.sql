{% macro test_expect_column_median_to_be_between(model, column_name,
                                                    minimum,
                                                    maximum,
                                                    partition_column=None,
                                                    partition_filter=None
                                                    ) %}

{% set expression %}
{{ dbt_expectations.median(column_name) }}
{% endset %}
{{ dbt_expectations.expression_between(model, 
                                                expression=expression,
                                                minimum=minimum, 
                                                maximum=maximum, 
                                                partition_column=partition_column, 
                                                partition_filter=partition_filter
                                                ) }}
{% endmacro %}
