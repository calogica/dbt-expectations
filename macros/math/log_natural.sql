{% macro log_natural(x) -%}
    {{ adapter.dispatch('log_natural', packages=dbt_expectations._get_namespaces()) (x) }}
{% endmacro %}

{% macro default__log_natural(x) %}

    ln({{ x }})

{%- endmacro -%}

{% macro bigquery__log_natural(x) %}

    ln({{ x }})

{%- endmacro -%}

{% macro snowflake__log_natural(x) %}

    ln({{ x }})

{%- endmacro -%}
