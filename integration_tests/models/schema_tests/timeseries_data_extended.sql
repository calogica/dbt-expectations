with dates as (

    {{ dbt_date.get_base_dates(n_dateparts=12, datepart='month') }}

),
add_row_values as (

    select
        d.date_day,
        cast(floor(100 * rnd) as {{ dbt_utils.type_int() }}) as row_value
    from
        dates d
        cross join
        unnest(generate_array(1, 10)) as rnd

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
