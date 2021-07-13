{%- test expect_table_columns_to_match_set(model, column_list, transform="upper") -%}
{%- if execute -%}
    {%- set column_list = column_list | map(transform) | list -%}
    {%- set relation_column_names = dbt_expectations._get_column_list(model, transform) -%}
    {%- set matching_columns = dbt_expectations._list_intersect(column_list, relation_column_names) -%}
    with test_data as (

        select
            '{{ relation_column_names | length }}' as number_columns,
            '{{ matching_columns | length }}' as number_matching_columns

    )
    select *
    from test_data
    where number_columns != number_matching_columns

{%- endif -%}
{%- endtest -%}
