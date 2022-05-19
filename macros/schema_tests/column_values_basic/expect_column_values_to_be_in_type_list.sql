{%- test expect_column_values_to_be_in_type_list(model, column_name, column_type_list) -%}
{%- if execute -%}

    {%- set column_name = column_name | upper -%}
    {%- set columns_in_relation = dbt_expectations._get_column_list(model) -%}
    {%- set column_type_list = column_type_list| map("upper") | list -%}
    with relation_columns as (

        {% for column in columns_in_relation %}
        select
            cast('{{ column.name | upper }}' as {{ dbt_utils.type_string() }}) as relation_column,
            cast('{{ column.dtype | upper }}' as {{ dbt_utils.type_string() }}) as relation_column_type
        {% if not loop.last %}union all{% endif %}
        {% endfor %}
    ),
    test_data as (

        select
            *
        from
            relation_columns
        where
            relation_column = '{{ column_name }}'
            and
            relation_column_type not in ('{{ column_type_list | join("', '") }}')

    )
    select *
    from test_data

{%- endif -%}
{%- endtest -%}
