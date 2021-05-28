# dbt-expectations v0.3.4

## Features

<<<<<<< HEAD
* Added support for optional `min_value` and `max_value` parameters to all`*_between_*` tests. ([#70](https://github.com/calogica/dbt-expectations/pull/70))
=======
* Added new `expect_column_stdev_to_be_greater_than` test ([#66](https://github.com/fishtown-analytics/dbt-utils/pull/276https://github.com/calogica/dbt-expectations/pull/66) Thanks [@MartinGuindon](https://github.com/MartinGuindon)!)
>>>>>>> 94e70a001772f429eadda48eedbc0cb4219d05b1

## Fixes

* Corrected a typo in the README ([#67](https://github.com/calogica/dbt-expectations/pull/67))

## Under the hood

* Refactored `get_select` function to generate SQL grouping more explicitly ([#63](https://github.com/calogica/dbt-expectations/pull/63)))

* Added dispatch call to `expect_table_row_count_to_equal` to make it easier to shim macros for the tsql-utils package ([#64](https://github.com/calogica/dbt-expectations/pull/64) Thanks [@alieus](https://github.com/alieus)!)
