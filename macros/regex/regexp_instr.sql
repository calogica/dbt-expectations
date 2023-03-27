{% macro regexp_instr(source_value, regexp, position=1, occurrence=1, is_raw=False, flags="") %}

    {{ adapter.dispatch('regexp_instr', 'dbt_expectations')(
        source_value, regexp, position, occurrence, is_raw, flags
    ) }}

{% endmacro %}

{% macro default__regexp_instr(source_value, regexp, position, occurrence, is_raw, flags) %}
{# unclear if other databases support raw strings or flags #}
{% if is_raw or flags %}
    {{ exceptions.warn(
            "is_raw and flags options are not supported for this adapter "
            ~ "and are being ignored."
    ) }}
{% endif %}
regexp_instr({{ source_value }}, '{{ regexp }}', {{ position }}, {{ occurrence }})
{% endmacro %}

{# Snowflake uses $$...$$ to escape raw strings #}
{% macro snowflake__regexp_instr(source_value, regexp, position, occurrence, is_raw, flags) %}
{%- set regexp = "$$" ~ regexp ~ "$$" if is_raw else "'" ~ regexp ~ "'" -%}
{% if flags %}{{ dbt_expectations._validate_flags(flags, 'cimes') }}{% endif %}
regexp_instr({{ source_value }}, {{ regexp }}, {{ position }}, {{ occurrence }}, 0, '{{ flags }}')
{% endmacro %}

{# BigQuery uses "r" to escape raw strings #}
{% macro bigquery__regexp_instr(source_value, regexp, position, occurrence, is_raw, flags) %}
{% if flags %}
    {{ exceptions.warn(
            "The flags option is not supported for BigQuery and is being ignored."
    ) }}
{% endif %}
{%- set regexp = "r'" ~ regexp ~ "'" if is_raw else "'" ~ regexp ~ "'" -%}
regexp_instr({{ source_value }}, {{ regexp }}, {{ position }}, {{ occurrence }})
{% endmacro %}

{# Postgres does not need to escape raw strings #}
{% macro postgres__regexp_instr(source_value, regexp, position, occurrence, is_raw, flags) %}
{% if flags %}{{ dbt_expectations._validate_flags(flags, 'bcegimnpqstwx') }}{% endif %}
coalesce(array_length((select regexp_matches({{ source_value }}, '{{ regexp }}', '{{ flags }}')), 1), 0)
{% endmacro %}

{# Unclear what Redshift does to escape raw strings #}
{% macro redshift__regexp_instr(source_value, regexp, position, occurrence, is_raw, flags) %}
{% if flags %}{{ dbt_expectations._validate_flags(flags, 'ciep') }}{% endif %}
regexp_instr({{ source_value }}, '{{ regexp }}', {{ position }}, {{ occurrence }}, 0, '{{ flags }}')
{% endmacro %}

{% macro _validate_flags(flags, alphabet) %}
{% for flag in flags %}
    {% if flag not in alphabet %}
    {{ exceptions.raise_compiler_error(
        "flag " ~ flag ~ " not in list of allowed flags for this adapter: " ~ alphabet | join(", ")
    ) }}
    {% endif %}
{% endfor %}
{% endmacro %}