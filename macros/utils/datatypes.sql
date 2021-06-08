{% macro postgres__type_timestamp() -%}
    timestamp without time zone
{%- endmacro %}



{%- macro type_datetime() -%}
  {{ return(adapter.dispatch('type_datetime', 'dbt_expectations')()) }}
{%- endmacro -%}

{% macro default__type_datetime() -%}
    datetime
{%- endmacro %}

{# see: https://docs.snowflake.com/en/sql-reference/data-types-datetime.html#datetime #}
{% macro snowflake__type_datetime() -%}
    timestamp_ntz
{%- endmacro %}

{% macro postgres__type_datetime() -%}
    timestamp without time zone
{%- endmacro %}
