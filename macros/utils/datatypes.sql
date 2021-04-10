{% macro postgres__type_timestamp() -%}
    timestamp without time zone
{%- endmacro %}


{%- macro type_datetime() -%}
  {{ return(adapter.dispatch('type_datetime', packages = dbt_expectations._get_namespaces())()) }}
{%- endmacro -%}

{% macro default__type_datetime() -%}
    datetime
{%- endmacro %}

{% macro snowflake__type_datetime() -%}
{# see: https://docs.snowflake.com/en/sql-reference/data-types-datetime.html#datetime #}
    timestamp_ntz
{%- endmacro %}

{% macro postgres__type_datetime() -%}
    timestamp without time zone
{%- endmacro %}
