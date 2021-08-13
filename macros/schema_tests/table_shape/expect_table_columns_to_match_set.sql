{%- test expect_table_columns_to_match_set(model, column_list, transform="upper") -%}
{%- if execute -%}
    {%- set column_list = column_list | map(transform) | list -%}
    {%- set relation_column_names = dbt_expectations._get_column_list(model, transform) -%}
    {%- set matching_columns = dbt_expectations._list_intersect(column_list, relation_column_names) -%}
    with relation_columns as (

        {% for col_name in relation_column_names %}
        select '{{ col_name }}' as relation_column
        {% if not loop.last %}union all{% endif %}
        {% endfor %}
    ),
    input_columns as (

        {% for col_name in column_list %}
        select '{{ col_name }}' as input_column
        {% if not loop.last %}union all{% endif %}
        {% endfor %}
    )
    select *
    from
        relation_columns r
        full outer join
        input_columns i on r.relation_column = i.input_column
    where
        -- catch any column in input list that is not in the list of table columns
        -- or any table column that is not in the input list
        r.relation_column is null or
        i.input_column is null

{%- endif -%}
{%- endtest -%}
