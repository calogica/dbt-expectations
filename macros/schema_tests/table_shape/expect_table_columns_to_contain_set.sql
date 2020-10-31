{%- macro test_expect_table_columns_to_contain_set(model, column_list) -%}
{%- set matching_columns = adapter.get_columns_in_relation(model) | selectattr("name", "in", column_list) | list -%}
select {{ column_list | length }} - {{ matching_columns | length }} 
{%- endmacro -%}