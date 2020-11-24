{% macro rand() -%}
    {{ adapter.dispatch('rand', packages=dbt_expectations._get_namespaces()) () }}
{% endmacro %}

{% macro bigquery__rand() %}

    rand()

{%- endmacro -%}

{% macro snowflake__rand(seed) %}

    uniform(0::float, 1::float, random())

{%- endmacro -%}
