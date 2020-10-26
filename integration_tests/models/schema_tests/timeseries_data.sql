{{
    config(
        materialized = 'table'
    )
}}
with date_dimension as (
    {{ dbt_date.get_base_dates(n_dateparts=12, datepart='month') }}
)
select
    d.date_day,
    cast(floor(100*rand()) as {{ dbt_utils.type_int() }}) as row_value
from
    date_dimension d


