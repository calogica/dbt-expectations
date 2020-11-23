{% macro test_expect_column_values_to_not_match_regex(model, column_name,
                                                    regex, mostly,
                                                    partition_column=None,
                                                    partition_filter=None
                                                    ) %}

{% set filter_cond = partition_column ~ " " ~ partition_filter if partition_column and partition_filter else None %}

{% set expression %}
{{ dbt_expectations.regexp_instr(column_name, regex) }} = 0
{% endset %}

{{ dbt_expectations.expression_is_true(model, 
                                        expression=expression,
                                        filter_cond=filter_cond
                                        )
                                        }}

{% endmacro %}