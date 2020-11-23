{% macro test_expect_column_values_to_not_match_like_pattern_list(model, column_name,
                                                    like_pattern_list,
                                                    match_on="any",
                                                    row_condition=None
                                                    ) %}

{% set expression %}
    {% for like_pattern in like_pattern_list %}
    {{ column_name }} not like '{{ like_pattern }}'
    {%- if not loop.last %}
    {{ " and " if match_on == "all" else " or "}}
    {% endif -%}
    {% endfor %}
{% endset %}

{{ dbt_expectations.expression_is_true(model,
                                        expression=expression,
                                        row_condition=row_condition
                                        )
                                        }}

{% endmacro %}
