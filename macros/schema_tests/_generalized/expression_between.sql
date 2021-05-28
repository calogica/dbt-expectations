{% macro test_expression_between(model,
                                 expression,
                                 min_value=None,
                                 max_value=None,
                                 group_by_columns=None,
                                 row_condition=None
                                 ) %}

    {{ dbt_expectations.expression_between(model, expression, min_value, max_value, group_by_columns, row_condition) }}

{% endmacro %}

{% macro expression_between(model,
                            expression,
                            min_value,
                            max_value,
                            group_by_columns,
                            row_condition
                            ) %}

{%- if min_value is none and max_value is none -%}
{{ exceptions.raise_compiler_error(
    "You have to provide either a min_value, max_value or both."
) }}
{%- endif -%}
{% set expression_min_max %}
( 1=1
{%- if min_value is not none %} and {{ expression }} >= {{ min_value }}{% endif %}
{%- if max_value is not none %} and {{ expression }} <= {{ max_value }}{% endif %}
)
{% endset %}

{{ dbt_expectations.expression_is_true(model,
                                        expression=expression_min_max,
                                        group_by_columns=group_by_columns,
                                        row_condition=row_condition)
                                        }}

{% endmacro %}
