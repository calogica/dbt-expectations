{% macro regexp_instr(source_value, regexp, position=1, occurrence=1) %}

    {{ adapter.dispatch('regexp_instr', packages=dbt_expectations._get_namespaces())(
        source_value, regexp, position, occurrence
    ) }}

{% endmacro %}

{% macro default__regexp_instr(source_value, regexp, position, occurrence) %}
regexp_instr({{ source_value }}, '{{ regexp }}', {{ position }}, {{ occurrence }})
{% endmacro %}
