{% test expect_row_values_to_have_recent_data(model,
                                                column_name,
                                                datepart,
                                                interval,
                                                row_condition=None) %}

 {{ adapter.dispatch('test_expect_row_values_to_have_recent_data', 'dbt_expectations') (model,
                                                                                        column_name,
                                                                                        datepart,
                                                                                        interval,
                                                                                        row_condition) }}

{% endtest %}

{% macro default__test_expect_row_values_to_have_recent_data(model, column_name, datepart, interval, row_condition) %}
{%- set default_start_date = '1970-01-01' -%}
with max_recency as (

    select max(cast({{ column_name }} as {{ dbt_utils.type_timestamp() }})) as max_timestamp
    from
        {{ model }}
    where
        cast({{ column_name }} as {{ dbt_utils.type_timestamp() }}) <= {{ dbt_date.now() }}
        {% if row_condition %}
        and {{ row_condition }}
        {% endif %}
)
select
    *
from
    max_recency
where
    -- if the row_condition excludes all row, we need to compare against a default date
    -- to avoid false negatives
    coalesce(max_timestamp, cast('{{ default_start_date }}' as {{ dbt_utils.type_timestamp() }}))
        <
        cast({{ dbt_utils.dateadd(datepart, interval * -1, dbt_date.now()) }} as {{ dbt_utils.type_timestamp() }})

{% endmacro %}
