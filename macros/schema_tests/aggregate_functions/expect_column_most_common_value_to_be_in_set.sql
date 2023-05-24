{% test expect_column_most_common_value_to_be_in_set(model,
                                                       column_name,
                                                       value_set,
                                                       top_n,
                                                       quote_values=True,
                                                       data_type=None,
                                                       row_condition=None,
                                                       ties_okay=False
                                                       ) -%}
    {# For Snowflake, using a default 'decimal' instead of dbt.type_numeric() 
        rounds up the value when casting #}
    {% set data_type = dbt.type_numeric() if not data_type else data_type %}
    {{ adapter.dispatch('test_expect_column_most_common_value_to_be_in_set', 'dbt_expectations') (
            model, column_name, value_set, top_n, quote_values, data_type, row_condition, ties_okay
        ) }}

{%- endtest %}

{% macro default__test_expect_column_most_common_value_to_be_in_set(model,
                                                                      column_name,
                                                                      value_set,
                                                                      top_n,
                                                                      quote_values,
                                                                      data_type,
                                                                      row_condition,
                                                                      ties_okay
                                                                      ) %}
with value_counts as (

    select
        {% if quote_values -%}
        {{ column_name }}
        {%- else -%}
        cast({{ column_name }} as {{ data_type }})
        {%- endif %} as value_field,
        count(*) as value_count

    from {{ model }}
    {% if row_condition %}
    where {{ row_condition }}
    {% endif %}

    group by {% if quote_values -%}
                {{ column_name }}
            {%- else -%}
                cast({{ column_name }} as {{ data_type }})
            {%- endif %}

),
value_counts_ranked as (

    select
        *,
        rank() over(order by value_count desc) as value_count_rank
    from
        value_counts

),
value_count_top_n as (

    select
        value_field
    from
        value_counts_ranked
    where
        value_count_rank <= {{ top_n }}

),
set_values as (

    {% for value in value_set -%}
    select
        {% if quote_values -%}
        '{{ value }}'
        {%- else -%}
        cast({{ value }} as {{ data_type }})
        {%- endif %} as value_field
    {% if not loop.last %}union all{% endif %}
    {% endfor %}

),
unique_set_values as (

    select distinct value_field
    from
        set_values

),
most_common_values_not_in_set as (
    select
        value_field
    from
        value_count_top_n
    where
        value_field not in (select value_field from unique_set_values)
),
{# Get the partial matches for ties_okay #}
most_common_values_in_set as (
    select 
        value_field 
    from 
        value_count_top_n 
    {{ dbt.intersect() }}
    select 
        value_field 
    from 
        unique_set_values
),
validation_errors as (
    {% if ties_okay -%}
    select 
        * 
    from 
        most_common_values_not_in_set
    where
        {# 
            If the intersection between the most common values and the values in the set is not empty, succeed. 
            Otherwise fail the test and select all the most common values from the column not in the set.
        #}
        not exists (
            select 1
            from most_common_values_in_set
        )
    {%- else -%}
    select * 
    from most_common_values_not_in_set
    {%- endif -%}
)

select *
from validation_errors

{% endmacro %}
