{%- macro test_expect_table_columns_to_match_set(model, column_list) -%}
{%- set columns_in_relation = adapter.get_columns_in_relation(model) -%}
{%- set matching_columns = columns_in_relation | selectattr("name", "in", column_list) | list -%}
select {{ columns_in_relation | list | length }} - {{ matching_columns | length }}
{%- endmacro -%}
