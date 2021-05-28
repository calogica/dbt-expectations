{%- macro test_expect_table_column_count_to_be_between(model,
                                                        min_value=None,
                                                        max_value=None
                                                        ) -%}
{%- if min_value is none and max_value is none -%}
{{ exceptions.raise_compiler_error(
    "You have to provide either a min_value, max_value or both."
) }}
{%- endif -%}
{%- if execute -%}
{%- set number_actual_columns = (adapter.get_columns_in_relation(model) | length) -%}

{%- set expression %}
( 1=1
{%- if min_value is not none %} and {{ number_actual_columns }} >= {{ min_value }}{% endif %}
{%- if max_value is not none %} and {{ number_actual_columns }} <= {{ max_value }}{% endif %}
)
{% endset -%}

select
    case
        when
            {{ expression }}
        then 0 else 1
    end
{%- endif -%}
{%- endmacro -%}
