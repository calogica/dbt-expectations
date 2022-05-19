{%- macro _get_column_name_list(model, transform="upper") -%}
    {%- set relation_columns = dbt_expectations._get_column_list(model) -%}
    {%- set relation_column_names = relation_columns | map(attribute="name") | map(transform) | list -%}
    {%- do return(relation_column_names) -%}
{%- endmacro -%}
