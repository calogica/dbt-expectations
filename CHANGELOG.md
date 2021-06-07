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

* Fixed `join` syntax because Twitter induced guilt: https://twitter.com/emilyhawkins__/status/1400967270537564160


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
