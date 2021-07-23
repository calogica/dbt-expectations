{% macro regexp_instr(source_value, regexp, position=1, occurrence=1) %}

    {{ adapter.dispatch('regexp_instr', 'dbt_expectations')(
        source_value, regexp, position, occurrence
    ) }}

{% endmacro %}

{% macro default__regexp_instr(source_value, regexp, position, occurrence) %}
regexp_instr({{ source_value }}, '{{ regexp }}', {{ position }}, {{ occurrence }})
{% endmacro %}

{% macro redshift__regexp_instr(source_value, regexp, position, occurrence) %}
regexp_instr({{ source_value }}, '{{ regexp }}', {{ position }}, {{ occurrence }})
{% endmacro %}

{% macro postgres__regexp_instr(source_value, regexp, position, occurrence) %}
array_length((select regexp_matches({{ source_value }}, '{{ regexp }}')), 1)
{% endmacro %}


{% macro spark__regexp_instr(source_value, regexp, position, occurrence) %}
case when {{ source_value }} rlike '{{ regexp }}' then 1 else 0 end
{% endmacro %}
