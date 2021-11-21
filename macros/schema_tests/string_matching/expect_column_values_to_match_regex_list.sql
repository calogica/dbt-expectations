{% test expect_column_values_to_match_regex_list(model, column_name,
                                                    regex_list,
                                                    match_on="any",
                                                    row_condition=None
                                                    ) %}

{% set expression %}
    {% for regex in regex_list %}
    {{ dbt_expectations.regexp_instr(column_name, regex) }} > 0
    {%- if not loop.last %}
    {{ " and " if match_on == "all" else " or "}}
    {% endif -%}
    {% endfor %}
{% endset %}

{{ dbt_expectations.expression_is_true(model,
                                        expression=expression,
                                        group_by_columns=None,
                                        row_condition=row_condition
                                        )
                                        }}

{% endtest %}
