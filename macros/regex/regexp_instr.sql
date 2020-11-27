{% macro regexp_instr(source_value, regexp, position=1, occurrence=1) %}

    {{ adapter.dispatch('regexp_instr', packages=dbt_expectations._get_namespaces())(
        source_value, regexp, position, occurrence
    ) }}

{% endmacro %}

{% macro default__regexp_instr(source_value, regexp, position, occurrence) %}
regexp_instr({{ source_value }}, '{{ regexp }}', {{ position }}, {{ occurrence }})
{% endmacro %}

{% macro spark__regexp_instr(source_value, regexp, position, occurrence) %}
case when {{ source_value }} rlike '{{ regexp }}' then 1 else 0 end
{% endmacro %}
