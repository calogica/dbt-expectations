{% test expect_row_values_to_have_recent_data(model, column_name, datepart, interval) %}
with max_recency as (

    select max({{ column_name }} ) as max_date
    from
        {{ model }}
    where
        {{ column_name }} <= {{ dbt_date.today() }}
)
select
    *
from
    max_recency
where
    max_date < {{ dbt_utils.dateadd(datepart, interval * -1, dbt_date.now()) }}

{% endtest %}
