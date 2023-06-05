{%- test expect_column_values_to_be_of_numeric_precision_and_scale(model, column_name, column_precision, column_scale) -%}
{%- if execute -%}

    {%- set column_name = column_name | upper -%}
    {%- set columns_in_relation = adapter.get_columns_in_relation(model) -%}

    with relation_columns as (

        {% for column in columns_in_relation %}
        select
            cast('{{ column.name | upper }}' as varchar) as relation_column,
            cast('{{ column.dtype | upper }}' as varchar) as relation_column_type,
            cast('{{ column.numeric_precision }}' as varchar) as relation_column_precision,
            cast('{{ column.numeric_scale }}' as varchar) as relation_column_scale
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
            and (
                relation_column_type <> 'NUMERIC'
                or 
                relation_column_precision <> '{{ column_precision }}'
                or
                relation_column_scale <> '{{ column_scale }}'
            )

    )
    select *
    from test_data

{%- endif -%}
{%- endtest -%}