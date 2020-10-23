{% macro test_expect_column_max_to_be_between(model) %}
{% set column_name = kwargs.get('column_name', kwargs.get('arg')) %}
{% set minimum = kwargs.get('minimum', 0) %}
{% set maximum = kwargs.get('maximum', kwargs.get('arg')) %}
{% set partition_column = kwargs.get('partition_column', kwargs.get('arg')) %}
{% set partition_filter =  kwargs.get('partition_filter', kwargs.get('arg')) %}
{{ dbt_expectations._test_agg_between(model, column_name=column_name, 
                                agg_func="max",
                                minimum=minimum, 
                                maximum=maximum, 
                                partition_column=partition_column, 
                                partition_filter=partition_filter
                                ) }}
{% endmacro %}