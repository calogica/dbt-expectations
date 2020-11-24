{%- macro test_expect_table_columns_to_match_set(model, column_list, transform="upper") -%}
{%- if execute -%}
    {%- set column_list = column_list | map(transform) | list -%}
    {%- set relation_column_names = dbt_expectations._get_column_list(model, transform) -%}
    {%- set matching_columns = dbt_expectations._list_intersect(column_list, relation_column_names) -%}
    select {{ relation_column_names | length }} - {{ matching_columns | length }}
{%- endif -%}
{%- endmacro -%}
