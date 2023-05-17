{% test expect_column_most_common_value_to_be_in_set(model,
                                                       column_name,
                                                       value_set,
                                                       top_n,
                                                       quote_values=True,
                                                       data_type="decimal",
                                                       row_condition=None,
                                                       ties_okay=False
                                                       ) -%}

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
        value_count_rank = {{ top_n }}

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
validation_errors as (
    {% if ties_okay -%}
    select mcvnis.* from most_common_values_not_in_set mcvnis
    , (select count(*) as cnt from most_common_values_not_in_set) as most_common_values_not_in_set_cnt
    , (select count(*) as cnt from value_count_top_n) as most_common_values_cnt
    where most_common_values_not_in_set_cnt.cnt >= most_common_values_cnt.cnt
    {%- else -%}
    select * from most_common_values_not_in_set
    {%- endif -%}
)

select *
from validation_errors

{% endmacro %}
