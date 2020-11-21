{% macro test_expect_column_values_to_be_between(model, column_name,
                                                   min_value,
                                                   max_value,
                                                   partition_column=None,
                                                   partition_filter=None
                                                   ) %}
{% set filter_cond = partition_column ~ " " ~ partition_filter if partition_column and partition_filter else None %}

{% set expression %}
{{ column_name ~ " >= " ~ min_value ~ " or " ~
   column_name ~ " <= " ~ max_value }}    
{% endset %}

{{ dbt_expectations.expression_is_true(model, 
                                        expression=expression,
                                        filter_cond=filter_cond
                                        )
                                        }}


{% endmacro %}