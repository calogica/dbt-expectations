with dates as (
    select * from {{ ref('timeseries_base') }}
),
groupings as (
    select * from {{ ref('series_4') }}
),
row_values as (
    select * from {{ ref('series_10') }}
),
add_row_values as (

    select
        cast(d.date_day as {{ dbt_expectations.type_datetime() }}) as date_day,
        cast(d.date_day as {{ dbt_expectations.type_timestamp() }}) as date_timestamp,
        cast(g.generated_number as {{ dbt_utils.type_int() }}) as group_id,
        cast(floor(100 * r.generated_number) as {{ dbt_utils.type_int() }}) as row_value
    from
        dates d
        cross join
        groupings g
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
