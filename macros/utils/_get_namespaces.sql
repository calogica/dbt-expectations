{% macro _get_namespaces() %}
  {% set override_namespaces = var('dbt_expectations_dispatch_list', []) %}
  {% do return(override_namespaces + ['dbt_expectations']) %}
{% endmacro %}
