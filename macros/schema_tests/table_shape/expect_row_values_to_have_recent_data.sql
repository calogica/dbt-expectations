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

    select max({{ column_name }} ) as max_date
    from
        {{ model }}
    where
        {{ column_name }} <= {{ dbt_date.today() }}
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
    coalesce(max_date, '{{ default_start_date }}')
        < {{ dbt_utils.dateadd(datepart, interval * -1, dbt_date.now()) }}

{% endmacro %}
