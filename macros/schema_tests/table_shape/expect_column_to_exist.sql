{%- macro test_expect_column_to_exist(model, column_name, column_index=None, transform="upper") -%}
{%- if execute -%}

    {%- set column_name = column_name | upper -%}
    {%- set relation_column_names = dbt_expectations._get_column_list(model, transform) -%}

    {%- set matching_column_index = relation_column_names.index(column_name) if column_name in relation_column_names else -1 %}

    {%- if column_index -%}

        {%- set column_index_0 = column_index - 1 if column_index > 0 else 0 -%}

        {%- set column_index_matches = true if matching_column_index == column_index_0 else false %}

    {%- else -%}

        {%- set column_index_matches = true -%}

    {%- endif %}
    /*
        DEBUG:
        select
            {{ column_name }} as column_name,
            {{ matching_column_index }} as matching_column_index,
            {{ column_index_0 }} as column_index_0,
            {{ column_index_matches }} as column_index_matches
    */
    select 1
    from (select 1) a
    where {{ 'false' if matching_column_index >= 0 and column_index_matches else 'true' }}

{%- endif -%}
{%- endmacro -%}
