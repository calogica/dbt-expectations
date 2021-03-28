with dates as (

    {{ dbt_date.get_base_dates(n_dateparts=12, datepart='month') }}

),
row_values as (
    {{ dbt_utils.generate_series(upper_bound=10) }}
),
add_row_values as (

    select
        d.date_day,
        cast(floor(100 * r.generated_number) as {{ dbt_utils.type_int() }}) as row_value
    from
        dates d
        cross join
        row_values r

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
