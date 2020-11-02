{%- macro test_expect_column_values_to_be_of_type(model, column_name, column_type) -%}
{%- set columns_in_relation = adapter.get_columns_in_relation(model) -%}
{%- set matching_column_types = columns_in_relation | 
    selectattr("name", "equalto", column_name) | 
    map(attribute="data_type") | 
    map("lower") | 
    select("equalto", column_type.lower()) | 
    list -%}
select 1 - {{ matching_column_types | length }}
{%- endmacro -%}