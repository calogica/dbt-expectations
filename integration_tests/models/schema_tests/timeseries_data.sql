with dates as (

    select * from {{ ref('timeseries_base') }}

),
add_row_values as (

    select
        d.date_day,
        cast(floor(100 * abs({{ dbt_expectations.rand() }})) as {{ dbt_utils.type_int() }}) as row_value
    from
        dates d

),
add_logs as (

    select
        *,
        {{ dbt_expectations.log_natural('nullif(row_value, 0)') }} as row_value_log
    from
        add_row_values
)
select
    *
from
    add_logs
