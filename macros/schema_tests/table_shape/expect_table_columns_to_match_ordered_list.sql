{%- macro test_expect_table_columns_to_match_ordered_list(model, column_list, transform="upper") -%}
{%- if execute -%}
    {%- set column_list = column_list | map(transform) | list -%}
    {%- set relation_column_names = dbt_expectations._get_column_list(model, transform) -%}

    {%- set ordered_column_names = column_list | join(", ") -%}
    {%- set ordered_relation_column_names = relation_column_names | join(", ") -%}
    with test_data as (

        select
            '{{ ordered_column_names }}' as ordered_column_names,
            '{{ ordered_relation_column_names }}' as ordered_relation_column_names

    )
    select *
    from test_data
    where ordered_column_names != ordered_relation_column_names
{%- endif -%}
{%- endmacro -%}
