with data_example as (
select * from {{ ref('data_test') }}

    union all

select
    2 as idx,
    '2020-10-23' as date_col,
    2 as col_numeric_a,
    -1 as col_numeric_b,
    'b' as col_string_a,
    'ab' as col_string_b,
    null as col_null

    union all

select
    2 as idx,
    '2020-10-24' as date_col,
    1 as col_numeric_a,
    -1 as col_numeric_b,
    'b' as col_string_a,
    'ab' as col_string_b,
    null as col_null
)

select *
        , SUM(col_numeric_a) over (partition by idx order by date_col) as rolling_sum_numeric_a
        , SUM(col_numeric_b) over (partition by idx order by date_col) as rolling_sum_numeric_b
from data_example