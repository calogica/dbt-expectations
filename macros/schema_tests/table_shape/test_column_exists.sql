{%- macro test_column_exists(model) -%}
{%- set column_name = kwargs.get('column_name', kwargs.get('arg')) -%}
{%- set matching_columns = adapter.get_columns_in_relation(model) | selectattr("name", "equalto", column_name) |  list -%}
select 1 - {{ matching_columns | length }} 
{%- endmacro -%}