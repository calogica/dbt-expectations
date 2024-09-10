select
    1 as idx,
    '2020-10-21' as date_col,
    cast(0 as {{ dbt.type_float() }}) as col_numeric_a,
    cast(1 as {{ dbt.type_float() }}) as col_numeric_b,
    'a' as col_string_a,
    'b' as col_string_b,
    cast(null as {{ dbt.type_string() }}) as col_null,
    cast(null as {{ dbt.type_string() }}) as col_null_2,
    1.0 as col_numeric_a_plus_b,
    2 as idx_multiplied_by_2,
    -2 as idx_multiplied_by_minus_2

union all

select
    2 as idx,
    '2020-10-22' as date_col,
    1 as col_numeric_a,
    0 as col_numeric_b,
    'b' as col_string_a,
    'ab' as col_string_b,
    null as col_null,
    null as col_null_2,
    1.0 as col_numeric_a_plus_b,
    4 as idx_multiplied_by_2,
    -4 as idx_multiplied_by_minus_2

union all

select
    3 as idx,
    '2020-10-23' as date_col,
    0.5 as col_numeric_a,
    0.5 as col_numeric_b,
    'c' as col_string_a,
    'abc' as col_string_b,
    null as col_null,
    null as col_null_2,
    1.0 as col_numeric_a_plus_b,
    6 as idx_multiplied_by_2,
    -6 as idx_multiplied_by_minus_2

union all

select
    4 as idx,
    '2020-10-23' as date_col,
    0.5 as col_numeric_a,
    0.5 as col_numeric_b,
    'c' as col_string_a,
    'abcd' as col_string_b,
    null as col_null,
    null as col_null_2,
    1.0 as col_numeric_a_plus_b,
    8 as idx_multiplied_by_2,
    -8 as idx_multiplied_by_minus_2
