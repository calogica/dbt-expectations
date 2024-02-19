{%- macro md5(string_value) -%}
    {{ return(adapter.dispatch('md5', 'dbt_expectations')(string_value)) }}
{% endmacro %}

{%- macro default__md5(string_value) -%}

  {{ dbt.hash(string_value) }}

{%- endmacro -%}


{%- macro trino__md5(string_value) -%}

  md5(cast({{ string_value }} as varbinary))

{%- endmacro -%}
