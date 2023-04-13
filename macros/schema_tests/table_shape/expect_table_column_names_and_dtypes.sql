{%- test expect_table_column_names_and_dtypes(model, mapping) -%}
{%- if execute -%}

    {%- set columns_in_relation = adapter.get_columns_in_relation(model) -%}

    WITH relation AS (
        {% for column in columns_in_relation %}
        SELECT
            CAST('{{ escape_single_quotes(column.name | upper) }}' AS {{ dbt.type_string() }}) AS relation_column_name,
            CAST('{{ column.dtype | upper }}' AS {{ dbt.type_string() }})                      AS relation_column_type
        {% if not loop.last %}UNION ALL{% endif %}
        {% endfor %}
    ),

    expected AS (
        {% for expected_column_name, expected_column_type in mapping.items() %}
        SELECT
            CAST('{{ escape_single_quotes(expected_column_name | upper) }}' AS {{ dbt.type_string() }}) AS expected_column_name,
            CAST('{{ expected_column_type | upper }}' AS {{ dbt.type_string() }})                       AS expected_column_type
        {% if not loop.last %}UNION ALL{% endif %}
        {% endfor %}
    ),

    a_minus_b as (
        select * from relation
        except
        select * from expected
    ),

    b_minus_a as (
        select * from expected
        except
        select * from relation
    ),

    unioned as (
        select 'relation' as found_in, * from a_minus_b
        union all
        select 'expected' as found_in, * from b_minus_a
    )

    select * from unioned

{%- endif -%}
{%- endtest -%}
