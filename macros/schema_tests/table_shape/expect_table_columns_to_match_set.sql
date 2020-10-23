{%- macro test_expect_table_columns_to_match_set(model) -%}
{%- set column_list = kwargs.get('column_list', kwargs.get('arg')) -%}
{%- set matching_columns = adapter.get_columns_in_relation(model) | selectattr("name", "in", column_list) |  list -%}
select {{ column_list | length }} - {{ matching_columns | length }} 
{%- endmacro -%}