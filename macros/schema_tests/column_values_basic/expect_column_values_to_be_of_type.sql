{%- macro test_expect_column_values_to_be_of_type(model, column_name, column_type) -%}
{%- if execute -%}

    {%- set column_name = column_name | upper -%}
    {%- set columns_in_relation = adapter.get_columns_in_relation(model) -%}
    {%- set column_type = column_type| upper -%}

    {%- set matching_column_types = [] -%}

    {%- for column in columns_in_relation -%}
        {%- if ((column.name | upper ) == column_name) and ((column.data_type | upper ) == column_type) -%}
            {%- do matching_column_types.append(column.name) -%}
        {%- endif -%}
    {%- endfor -%}
    select 1 - {{ matching_column_types | length }}

{%- endif -%}
{%- endmacro -%}
