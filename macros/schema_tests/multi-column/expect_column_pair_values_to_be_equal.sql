
{% macro test_expect_column_pair_values_to_be_equal(model, column_A, column_B) %}
{% set partition_column = kwargs.get('partition_column', kwargs.get('arg')) %}
{% set partition_filter =  kwargs.get('partition_filter', kwargs.get('arg')) %}
{% set operator = "!=" %}

{{ dbt_expectations.column_pair_values_compare_A_to_B(model, 
                                        column_A,
                                        column_B,
                                        operator,
                                        partition_column,
                                        partition_filter
                                        )
                                        }}

{% endmacro %}