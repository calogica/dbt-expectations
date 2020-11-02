{%- macro test_expect_column_values_to_be_in_type_list(model, column_name, column_type_list) -%}
{%- set columns_in_relation = adapter.get_columns_in_relation(model) -%}
{%- set column_type_list = column_type_list| map("lower") -%}
{%- set matching_column_types = columns_in_relation | 
    selectattr("name", "equalto", column_name) | 
    map(attribute="data_type") | 
    map("lower") | 
    select("in", column_type_list) | 
    list -%}
select 1 - {{ matching_column_types | length }}
{%- endmacro -%}