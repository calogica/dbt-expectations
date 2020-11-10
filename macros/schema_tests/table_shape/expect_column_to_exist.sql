{%- macro test_expect_column_to_exist(model, column_name, column_index=None) -%}
{% if execute %}
{%- set relation_columns = adapter.get_columns_in_relation(model) | list -%}
{%- if column_index -%}
    {%- set column_index_0 = column_index - 1 if column_index > 0 else 0 -%}
    {%- set matching_column_by_name = relation_columns | selectattr("name", "eq", column_name) | list | first %}
    {%- set matching_column_index = relation_columns.index(matching_column_by_name) -%}
    {% if matching_column_index == column_index_0 -%}
        {%- set matching_column = relation_columns[matching_column_index] %}
    {%- else -%}
    -- column name matched but column_index is {{ matching_column_index }} (expected {{ column_index_0 }})
    {%- endif -%}
{%- else -%}
    {%- set matching_column = relation_columns | selectattr("name", "eq", column_name) | first %}
{%- endif %}
select 1 - {{ 1 if matching_column else 0 }} 
{%- endif -%}
{%- endmacro -%}