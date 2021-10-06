# dbt-expectations v0.4.3

## Fixes
* Fixes incompatibility on Snowflake with use of `row_number()` without `order by` in `expect_table_columns_to_match_ordered_list`([#112](https://github.com/calogica/dbt-expectations/pull/112))

## Features

## Under the hood
* Supports dbt 0.21.x

# dbt-expectations v0.4.2

## Features
 * Added `row_condition` to `expect_grouped_row_values_to_have_recent_data` and `expect_row_values_to_have_recent_data` to allow for partition filtering before applying the recency test ([#106](https://github.com/calogica/dbt-expectations/pull/106) w/ [@edbizarro](https://github.com/edbizarro))

## Under the hood
* Converted Jinja set logic to SQL joins to make it easier to follow and iterate in the future ([#108](https://github.com/calogica/dbt-expectations/pull/108))

# dbt-expectations v0.4.1

## Fixes
* `expect_table_columns_to_match_list` remove `''` to leave columns as numbers ([#98](https://github.com/calogica/dbt-expectations/issues/98))

* `expect_table_columns_to_match_ordered_list` now explicitly casts the column list to a string type ([#99](https://github.com/calogica/dbt-expectations/issues/99))

* Fixes regex matching tests for Redshift by adding a Redshift specific adapter macro in `regexp_instr` ([#99](https://github.com/calogica/dbt-expectations/pull/102) @mirosval)

# dbt-expectations v0.4.0

## Breaking Changes

* Requires `dbt >= 0.20`

* Requires `dbt-date >= 0.4.0`

* Updates test macros to tests to support `dbt >= 0.20`

* Updates calls to adapter.dispatch to support `dbt >= 0.20` (see [Changes to dispatch in dbt v0.20 #78](https://github.com/calogica/dbt-expectations/issues/78))

# dbt-expectations v0.3.7

* Fix join in `expect_column_values_to_be_in_set` ([#91](https://github.com/calogica/dbt-expectations/pull/91) @ahmedrad)
* Add support for Redshift `random` function in `rand` macro ([#92](https://github.com/calogica/dbt-expectations/pull/92) @ahmedrad)

# dbt-expectations v0.3.6

* Remove unnecessary macro to fix issue with 0.19.2 ([#88](https://github.com/calogica/dbt-expectations/pull/88))

# dbt-expectations v0.3.5

## Features
* Added a new macro, `expect_row_values_to_have_data_for_every_n_datepart`, which tests whether a model has values for every grouped `date_part`.


    For example, this tests whether a model has data for every `day` (grouped on `date_col`) from either a specified `start_date` and `end_date`, or for the `min`/`max` value of the specified `date_col`.


    ```yaml
    tests:
        - dbt_expectations.expect_row_values_to_have_data_for_every_n_datepart:
            date_col: date_day
            date_part: day
    ```

## Fixes

* Updated description of type check tests ([#84](https://github.com/calogica/dbt-expectations/pull/84) @noel)

* Fixed `join` syntax because Twitter induced guilt: https://twitter.com/emilyhawkins__/status/1400967270537564160

* Bump version of dbt-date to `< 0.4.0` ([#85](https://github.com/calogica/dbt-expectations/issues/85))


# dbt-expectations v0.3.4

## Features

* Added support for optional `min_value` and `max_value` parameters to all`*_between_*` tests. ([#70](https://github.com/calogica/dbt-expectations/pull/70))

* Added support for `strictly` parameter to `between` tests. If set to `True`, `striclty` changes the operators `>=` and `<=` to`>` and `<`.

    For example, while

    ```yaml
    dbt_expectations.expect_column_stdev_to_be_between:
        min_value: 0
    ```

    evaluates to `>= 0`,

    ```yaml
    dbt_expectations.expect_column_stdev_to_be_between:
        min_value: 0
        strictly: True
    ```

    evaluates to `> 0`.
    ([#72](https://github.com/calogica/dbt-expectations/issues/72), [#74](https://github.com/calogica/dbt-expectations/pull/74))

## Fixes

* Corrected a typo in the README ([#67](https://github.com/calogica/dbt-expectations/pull/67))

## Under the hood

* Refactored `get_select` function to generate SQL grouping more explicitly ([#63](https://github.com/calogica/dbt-expectations/pull/63)))

* Added dispatch call to `expect_table_row_count_to_equal` to make it easier to shim macros for the tsql-utils package ([#64](https://github.com/calogica/dbt-expectations/pull/64) Thanks [@alieus](https://github.com/alieus)!)
