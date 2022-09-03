{% macro regexp_instr(source_value, regexp, position=1, occurrence=1) %}

    {{ adapter.dispatch('regexp_instr', 'dbt_expectations')(
        source_value, regexp, position, occurrence
    ) }}

{% endmacro %}

{% macro default__regexp_instr(source_value, regexp, position, occurrence) %}
regexp_instr({{ source_value }}, '{{ regexp }}', {{ position }}, {{ occurrence }})
{% endmacro %}

{# Snowflake uses $$...$$ to escape raw strings #}
{% macro snowflake__regexp_instr(source_value, regexp, position, occurrence) %}
regexp_instr({{ source_value }}, $${{ regexp }}$$, {{ position }}, {{ occurrence }})
{% endmacro %}

{# BigQuery uses "r" to escape raw strings #}
{% macro bigquery__regexp_instr(source_value, regexp, position, occurrence) %}
regexp_instr({{ source_value }}, r'{{ regexp }}', {{ position }}, {{ occurrence }})
{% endmacro %}

{# Postgres does not need to escape raw strings #}
{% macro postgres__regexp_instr(source_value, regexp, position, occurrence) %}
array_length((select regexp_matches({{ source_value }}, '{{ regexp }}')), 1)
{% endmacro %}

{# Unclear what Redshift does to escape raw strings #}
{% macro redshift__regexp_instr(source_value, regexp, position, occurrence) %}
regexp_instr({{ source_value }}, '{{ regexp }}', {{ position }}, {{ occurrence }})
{% endmacro %}
