{%- macro test_columns_match_list(model) -%}
{%- set column_list = kwargs.get('column_list', kwargs.get('arg')) -%}
{%- set matching_columns = adapter.get_columns_in_relation(model) | selectattr("name", "in", column_list) |  list -%}
select {{ column_list | length }} - {{ matching_columns | length }} 
{%- endmacro -%}