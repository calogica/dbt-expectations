{%- macro test_expect_column_values_to_be_in_type_list(model, column_name, column_type_list) -%}
{%- if execute -%}

    {%- set column_name = column_name | upper -%}
    {%- set columns_in_relation = adapter.get_columns_in_relation(model) -%}
    {%- set column_type_list = column_type_list| map("upper") | list -%}

    {%- set matching_column_types = [] -%}

    {%- for column in columns_in_relation -%}
        {%- if ((column.name | upper ) == column_name) and ((column.dtype | upper ) in column_type_list) -%}
            {%- do matching_column_types.append(column.name) -%}
        {%- endif -%}
    {%- endfor -%}
    select 1 - {{ matching_column_types | length }}

{%- endif -%}
{%- endmacro -%}
