{%- macro test_expect_table_row_count_to_be_between(model, 
                                                      minimum, 
                                                      maximum, 
                                                      partition_column=None,
                                                      partition_filter=None
                                                    ) -%}
{% set expression %}
count(*) 
{% endset %}
{{ dbt_expectations.expression_between(model, 
                                        expression=expression,
                                        minimum=minimum, 
                                        maximum=maximum, 
                                        partition_column=partition_column, 
                                        partition_filter=partition_filter
                                        ) }}      
{%- endmacro -%}