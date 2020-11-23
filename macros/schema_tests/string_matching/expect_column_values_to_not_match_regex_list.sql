{% macro test_expect_column_values_to_not_match_regex_list(model, column_name,
                                                    regex_list,
                                                    match_on="any",
                                                    mostly=None,
                                                    partition_column=None,
                                                    partition_filter=None
                                                    ) %}

{% set filter_cond = partition_column ~ " " ~ partition_filter if partition_column and partition_filter else None %}

{% set expression %}
{% for regex in regex_list %}
{{ dbt_expectations.regexp_instr(column_name, regex) }} = 0
{%- if not loop.last %}
{{ " and " if match_on == "all" else " or "}}
{% endif -%}
{% endfor %}
{% endset %}

{{ dbt_expectations.expression_is_true(model,
                                        expression=expression,
                                        filter_cond=filter_cond
                                        )
                                        }}

{% endmacro %}
