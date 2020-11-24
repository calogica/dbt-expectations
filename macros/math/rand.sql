{% macro rand(seed) -%}
    {{ adapter.dispatch('rand', packages=dbt_expectations._get_namespaces()) (seed) }}
{% endmacro %}

{% macro default__rand(seed) %}

    rand({{ seed }})

{%- endmacro -%}

{% macro bigquery__rand(seed) %}

    rand()

{%- endmacro -%}

{% macro snowflake__rand(seed) %}

    random({{ seed }})

{%- endmacro -%}
