{% macro test_expect_column_values_to_not_be_null(model) %}
{% set column_name = kwargs.get('column_name', kwargs.get('arg')) %}
{% set partition_column = kwargs.get('partition_column', kwargs.get('arg')) %}
{% set partition_filter =  kwargs.get('partition_filter', kwargs.get('arg')) %}
{% set filter_cond = partition_column ~ " " ~ partition_filter if partition_column and partition_filter else None %}
{% set expression = column_name ~ " is not null" %}

{{ dbt_expectations.expression_is_true(model, 
                                        expression=expression,
                                        filter_cond=filter_cond
                                        )
                                        }}
{% endmacro %}