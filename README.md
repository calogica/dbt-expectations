# dbt-expectations

Extension package for [**dbt**](https://github.com/fishtown-analytics/dbt) inspired by the [Great Expectations package for Python](https://greatexpectations.io/). The intent is to allow dbt users to deploy GE-like tests in their data warehouse directly from dbt, vs having to add another integration with their data warehouse.

## Install

`db-expectations` currently support `dbt 0.19.x`.

Check [dbt Hub](https://hub.getdbt.com/calogica/dbt_expectations/latest/) for the latest installation instructions, or [read the docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

Include in `packages.yml`

```yaml
packages:
  - package: calogica/dbt_expectations
    version: [">=0.3.0", "<0.4.0"]
    # <see https://github.com/calogica/dbt-expectations/releases/latest> for the latest version tag
```

For latest release, see [https://github.com/calogica/dbt-expectations/releases](https://github.com/calogica/dbt-expectations/releases)

### Dependencies

This package includes a reference to [**dbt-date**](https://github.com/calogica/dbt-date) which in turn references [**dbt-utils**](https://github.com/fishtown-analytics/dbt-utils) so there's no need to also import dbt-utils in your local project.

Note: we no longer include `spark_utils` in this package to avoid versioning conflicts. If you are running this package on non-core (Snowflake, BigQuery, Redshift, Postgres) platforms, you will need to use a package like `spark_utils` to shim macros.

For example, in `packages.yml`, you will need to include the relevant package:

```yaml
  - package: fishtown-analytics/spark_utils
    version: <latest or range>
```

And reference in the dispatch list for `dbt_utils` in `dbt_project.yml`:

```yaml
vars:
    dbt_utils_dispatch_list: [spark_utils]
```

### Variables

The following variables need to be defined in your `dbt_project.yml` file:

```yaml
vars:
  'dbt_date:time_zone': 'America/Los_Angeles'
```

You may specify [any valid timezone string](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) in place of `America/Los_Angeles`.
For example, use `America/New_York` for East Coast Time.

### Integration Tests (Developers Only)

This project contains integration tests for all test macros in a separate `integration_tests` dbt project contained in this repo.

To run the tests:

1. You will need a profile called `integration_tests` in `~/.dbt/profiles.yml` pointing to a writable database.
2. Then, from within the `integration_tests` folder, run `dbt seed` to load `data_test.csv` to the `test` schema of your database.
3. Then run `dbt test` to run the tests specified in `integration_tests/models/schema_tests/schema.yml`

## Available Tests

### Table shape

- [expect_column_to_exist](#expect_column_to_exist)
- [expect_row_values_to_have_recent_data](#expect_row_values_to_have_recent_data)
- [expect_grouped_row_values_to_have_recent_data](#expect_grouped_row_values_to_have_recent_data)
- [expect_table_column_count_to_be_between](#expect_table_column_count_to_be_between)
- [expect_table_column_count_to_equal_other_table](#expect_table_column_count_to_equal_other_table)
- [expect_table_column_count_to_equal](#expect_table_column_count_to_equal)
- [expect_table_columns_to_contain_set](#expect_table_columns_to_contain_set)
- [expect_table_columns_to_match_ordered_list](#expect_table_columns_to_match_ordered_list)
- [expect_table_columns_to_match_set](#expect_table_columns_to_match_set)
- [expect_table_row_count_to_be_between](#expect_table_row_count_to_be_between)
- [expect_table_row_count_to_equal_other_table](#expect_table_row_count_to_equal_other_table)
- [expect_table_row_count_to_equal_other_table_times_factor](#expect_table_row_count_to_equal_other_table_times_factor)
- [expect_table_row_count_to_equal](#expect_table_row_count_to_equal)

### Missing values, unique values, and types

- [expect_column_values_to_be_null](#expect_column_values_to_be_null)
- [expect_column_values_to_not_be_null](#expect_column_values_to_not_be_null)
- [expect_column_values_to_be_unique](#expect_column_values_to_be_unique)
- [expect_column_values_to_be_of_type](#expect_column_values_to_be_of_type)
- [expect_column_values_to_be_in_type_list](#expect_column_values_to_be_in_type_list)

### Sets and ranges

- [expect_column_values_to_be_in_set](#expect_column_values_to_be_in_set)
- [expect_column_values_to_not_be_in_set](#expect_column_values_to_not_be_in_set)
- [expect_column_values_to_be_between](#expect_column_values_to_be_between)
- [expect_column_values_to_be_decreasing](#expect_column_values_to_be_decreasing)
- [expect_column_values_to_be_increasing](#expect_column_values_to_be_increasing)

### String matching

- [expect_column_value_lengths_to_be_between](#expect_column_value_lengths_to_be_between)
- [expect_column_value_lengths_to_equal](#expect_column_value_lengths_to_equal)
- [expect_column_values_to_match_like_pattern](#expect_column_values_to_match_like_pattern)
- [expect_column_values_to_match_like_pattern_list](#expect_column_values_to_match_like_pattern_list)
- [expect_column_values_to_match_regex](#expect_column_values_to_match_regex)
- [expect_column_values_to_match_regex_list](#expect_column_values_to_match_regex_list)
- [expect_column_values_to_not_match_like_pattern](#expect_column_values_to_not_match_like_pattern)
- [expect_column_values_to_not_match_like_pattern_list](#expect_column_values_to_not_match_like_pattern_list)
- [expect_column_values_to_not_match_regex](#expect_column_values_to_not_match_regex)
- [expect_column_values_to_not_match_regex_list](#expect_column_values_to_not_match_regex_list)


### Aggregate functions

- [expect_column_distinct_count_to_be_greater_than](#expect_column_distinct_count_to_be_greater_than)
- [expect_column_distinct_count_to_equal_other_table](#expect_column_distinct_count_to_equal_other_table)
- [expect_column_distinct_count_to_equal](#expect_column_distinct_count_to_equal)
- [expect_column_distinct_values_to_be_in_set](#expect_column_distinct_values_to_be_in_set)
- [expect_column_distinct_values_to_contain_set](#expect_column_distinct_values_to_contain_set)
- [expect_column_distinct_values_to_equal_set](#expect_column_distinct_values_to_equal_set)
- [expect_column_max_to_be_between](#expect_column_max_to_be_between)
- [expect_column_mean_to_be_between](#expect_column_mean_to_be_between)
- [expect_column_median_to_be_between](#expect_column_median_to_be_between)
- [expect_column_min_to_be_between](#expect_column_min_to_be_between)
- [expect_column_most_common_value_to_be_in_set](#expect_column_most_common_value_to_be_in_set)
- [expect_column_proportion_of_unique_values_to_be_between](#expect_column_proportion_of_unique_values_to_be_between)
- [expect_column_quantile_values_to_be_between](#expect_column_quantile_values_to_be_between)
- [expect_column_stdev_to_be_between](#expect_column_stdev_to_be_between)
- [expect_column_stdev_to_be_greater_than](#expect_column_stdev_to_be_greater_than)
- [expect_column_sum_to_be_between](#expect_column_sum_to_be_between)
- [expect_column_unique_value_count_to_be_between](#expect_column_unique_value_count_to_be_between)

### Multi-column

- [expect_column_pair_values_A_to_be_greater_than_B](#expect_column_pair_values_A_to_be_greater_than_B)
- [expect_column_pair_values_to_be_equal](#expect_column_pair_values_to_be_equal)
- [expect_column_pair_values_to_be_in_set](#expect_column_pair_values_to_be_in_set)
- [expect_compound_columns_to_be_unique](#expect_compound_columns_to_be_unique)
- [expect_multicolumn_sum_to_equal](#expect_multicolumn_sum_to_equal)
- [expect_select_column_values_to_be_unique_within_record](#expect_select_column_values_to_be_unique_within_record)


### Distributional functions

- [expect_column_values_to_be_within_n_moving_stdevs](#expect_column_values_to_be_within_n_moving_stdevs)
- [expect_column_values_to_be_within_n_stdevs](#expect_column_values_to_be_within_n_stdevs)
- [expect_row_values_to_have_data_for_every_n_datepart](#expect_row_values_to_have_data_for_every_n_datepart)

## Documentation

### [expect_column_to_exist](macros/schema_tests/table_shape/expect_column_to_exist.sql)

Expect the specified column to exist.

*Applies to:* Column

```yaml
tests:
- dbt_expectations.expect_column_to_exist
```

### [expect_row_values_to_have_recent_data](macros/schema_tests/table_shape/expect_row_values_to_have_recent_data.sql)

Expect the model to have rows that are at least as recent as the defined interval prior to the current timestamp.

*Applies to:* Column

```yaml
tests:
  - dbt_expectations.expect_table_column_count_to_be_between:
        datepart: day
        interval: 1
```

### [expect_grouped_row_values_to_have_recent_data](macros/schema_tests/table_shape/expect_grouped_row_values_to_have_recent_data.sql)

Expect the model to have **grouped** rows that are at least as recent as the defined interval prior to the current timestamp.
Uuse this to test whether there is recent data for each grouped row defined by `group_by` (which is a list of columns) and a `timestamp_column`.

*Applies to:* Model, Seed, Source

```yaml
models: # or seeds:
  - name : my_model
    tests :
        - dbt_expectations.expect_grouped_row_values_to_have_recent_data:
            group_by: [group_id]
            timestamp_column: date_day
            datepart: day
            interval: 1
        # or also:
        - dbt_expectations.expect_grouped_row_values_to_have_recent_data:
            group_by: [group_id, other_group_id]
            timestamp_column: date_day
            datepart: day
            interval: 1
```


### [expect_table_column_count_to_be_between](macros/schema_tests/table_shape/expect_table_column_count_to_be_between.sql)

Expect the number of columns in a model to be between two values.

*Applies to:* Column

```yaml
tests:
  - dbt_expectations.expect_table_column_count_to_be_between:
      min_value: 1
      max_value: 4
```

### [expect_table_column_count_to_equal_other_table](macros/schema_tests/table_shape/expect_table_column_count_to_equal_other_table.sql)

Expect the number of columns in a model to match another model.

*Applies to:* Model, Seed, Source

```yaml
models: # or seeds:
  - name: my_model
    tests:
    - dbt_expectations.expect_table_column_count_to_equal_other_table:
        compare_model: ref("other_model")
```

### [expect_table_column_count_to_equal](macros/schema_tests/table_shape/expect_table_column_count_to_equal.sql)

Expect the number of columns in a model to be equal to `expected_number_of_columns`.

*Applies to:* Model, Seed, Source

```yaml
models: # or seeds:
  - name: my_model
    tests:
    - dbt_expectations.expect_table_column_count_to_equal:
        value: 7
```

### [expect_table_columns_to_match_ordered_list](macros/schema_tests/table_shape/expect_table_columns_to_match_ordered_list.sql)

Expect the columns to exactly match a specified list.

*Applies to:* Model, Seed, Source

```yaml
models: # or seeds:
  - name: my_model
    tests:
    - dbt_expectations.expect_table_columns_to_match_ordered_list:
        column_list: ["col_a", "col_b"]
```

### [expect_table_columns_to_match_set](macros/schema_tests/table_shape/expect_table_columns_to_match_set.sql)

Expect the columns in a model to match a given list.

*Applies to:* Model, Seed, Source

```yaml
models: # or seeds:
  - name: my_model
    tests:
    - dbt_expectations.expect_table_columns_to_match_set:
        column_list: ["col_a", "col_b"]
```

### [expect_table_row_count_to_be_between](macros/schema_tests/table_shape/expect_table_row_count_to_be_between.sql)

Expect the number of rows in a model to be between two values.

*Applies to:* Model, Seed, Source

```yaml
models: # or seeds:
  - name: my_model
    tests:
    - dbt_expectations.expect_table_row_count_to_be_between:
        min_value: 1
        max_value: 4
```

### [expect_table_row_count_to_equal_other_table](macros/schema_tests/table_shape/expect_table_row_count_to_equal_other_table.sql)

Expect the number of rows in a model match another model.

*Applies to:* Model, Seed, Source

```yaml
models: # or seeds:
  - name: my_model
    tests:
    - dbt_expectations.expect_table_row_count_to_equal_other_table:
        compare_model: ref("other_model")
```

### [expect_table_row_count_to_equal_other_table_times_factor](macros/schema_tests/table_shape/expect_table_row_count_to_equal_other_table_times_factor.sql)

Expect the number of rows in a model to match another model times a preconfigured factor.

*Applies to:* Model, Seed, Source

```yaml
models: # or seeds:
  - name: my_model
    tests:
    - dbt_expectations.expect_table_column_count_to_equal_other_table_times_factor:
        compare_model: ref("other_model")
        factor: 13
```

### [expect_table_row_count_to_equal](macros/schema_tests/table_shape/expect_table_row_count_to_equal.sql)

Expect the number of rows in a model to be equal to `expected_number_of_rows`.

*Applies to:* Model, Seed, Source

```yaml
models: # or seeds:
  - name: my_model
    tests:
    - dbt_expectations.expect_table_row_count_to_equal:
        value: 4
```

### [expect_column_values_to_be_unique](macros/schema_tests/column_values_basic/expect_column_values_to_be_unique.sql)

Expect each column value to be unique.

*Applies to:* Column

```yaml
tests:
  - dbt_expectations.expect_column_values_to_be_unique
```

### [expect_column_values_to_not_be_null](macros/schema_tests/column_values_basic/expect_column_values_to_not_be_null.sql)

Expect column values to not be null.

*Applies to:* Column

```yaml
tests:
  - dbt_expectations.expect_column_values_to_not_be_null
```

### [expect_column_values_to_be_null](macros/schema_tests/column_values_basic/expect_column_values_to_be_null.sql)

Expect column values to be null.

*Applies to:* Column

```yaml
tests:
  - dbt_expectations.expect_column_values_to_be_null
```

### [expect_column_values_to_be_of_type](macros/schema_tests/column_values_basic/expect_column_values_to_be_of_type.sql)

Expect a column to contain values of a specified data type.

*Applies to:* Column

```yaml
tests:
  - dbt_expectations.expect_column_values_to_be_of_type:
      column_type: date
```

### [expect_column_values_to_be_in_type_list](macros/schema_tests/column_values_basic/expect_column_values_to_be_in_type_list.sql)

Expect a column to contain values from a specified type list.

*Applies to:* Column

```yaml
tests:
  - dbt_expectations.expect_column_values_to_be_in_type_list:
      column_type_list: [date, datetime]
```

### [expect_column_values_to_be_in_set](macros/schema_tests/column_values_basic/expect_column_values_to_be_in_set.sql)

Expect each column value to be in a given set.

*Applies to:* Column

```yaml
tests:
  - dbt_expectations.expect_column_values_to_be_in_set:
      value_set: ['a','b','c']
```

### [expect_column_values_to_be_between](macros/schema_tests/column_values_basic/expect_column_values_to_be_between.sql)

Expect each column value to be between two values.

*Applies to:* Column

```yaml
tests:
  - dbt_expectations.expect_column_values_to_be_between:
      min_value: 0
      max_value: 10
```

### [expect_column_values_to_not_be_in_set](macros/schema_tests/column_values_basic/expect_column_values_to_not_be_in_set.sql)

Expect each column value not to be in a given set.

*Applies to:* Column

```yaml
tests:
  - dbt_expectations.expect_column_values_to_not_be_in_set:
      value_set: ['e','f','g']
```

### [expect_column_values_to_be_increasing](macros/schema_tests/column_values_basic/expect_column_values_to_be_increasing.sql)

Expect column values to be increasing.

If strictly=True, then this expectation is only satisfied if each consecutive value is strictly increasing–equal values are treated as failures.

*Applies to:* Column

```yaml
tests:
  - dbt_expectations.expect_column_values_to_be_increasing:
      sort_column: date_day
```

### [expect_column_values_to_be_decreasing](macros/schema_tests/column_values_basic/expect_column_values_to_be_decreasing.sql)

Expect column values to be decreasing.

If strictly=True, then this expectation is only satisfied if each consecutive value is strictly increasing–equal values are treated as failures.

*Applies to:* Column

```yaml
tests:
  - dbt_expectations.expect_column_values_to_be_decreasing:
      sort_column: col_numeric_a
      strictly: false
```

### [expect_column_value_lengths_to_be_between](macros/schema_tests/string_matching/expect_column_value_lengths_to_be_between.sql)

Expect column entries to be strings with length between a min_value value and a max_value value (inclusive).

*Applies to:* Column

```yaml
tests:
  - dbt_expectations.expect_column_value_lengths_to_be_between:
      min_value: 1
      max_value: 4
```

### [expect_column_value_lengths_to_equal](macros/schema_tests/string_matching/expect_column_value_lengths_to_equal.sql)

Expect column entries to be strings with length equal to the provided value.

*Applies to:* Column

```yaml
tests:
  - dbt_expectations.expect_column_value_lengths_to_equal:
      value: 10
```

### [expect_column_values_to_match_regex](macros/schema_tests/string_matching/expect_column_values_to_match_regex.sql)

Expect column entries to be strings that match a given regular expression. Valid matches can be found anywhere in the string, for example "[at]+" will identify the following strings as expected: "cat", "hat", "aa", "a", and "t", and the following strings as unexpected: "fish", "dog".

*Applies to:* Column

```yaml
tests:
  - dbt_expectations.expect_column_values_to_match_regex:
      regex: "[at]+"
```

### [expect_column_values_to_not_match_regex](macros/schema_tests/string_matching/expect_column_values_to_not_match_regex.sql)

Expect column entries to be strings that do NOT match a given regular expression. The regex must not match any portion of the provided string. For example, "[at]+" would identify the following strings as expected: "fish”, "dog”, and the following as unexpected: "cat”, "hat”.

*Applies to:* Column

```yaml
tests:
  - dbt_expectations.expect_column_values_to_not_match_regex:
      regex: "[at]+"
```

### [expect_column_values_to_match_regex_list](macros/schema_tests/string_matching/expect_column_values_to_match_regex_list.sql)

Expect the column entries to be strings that can be matched to either any of or all of a list of regular expressions. Matches can be anywhere in the string.

*Applies to:* Column

```yaml
tests:
  - dbt_expectations.expect_column_values_to_match_regex_list:
      regex_list: ["@[^.]*", "&[^.]*"]
```

### [expect_column_values_to_not_match_regex_list](macros/schema_tests/string_matching/expect_column_values_to_not_match_regex_list.sql)

Expect the column entries to be strings that do not match any of a list of regular expressions. Matches can be anywhere in the string.

*Applies to:* Column

```yaml
tests:
  - dbt_expectations.expect_column_values_to_not_match_regex_list:
      regex_list: ["@[^.]*", "&[^.]*"]
```

### [expect_column_values_to_match_like_pattern](macros/schema_tests/string_matching/expect_column_values_to_match_like_pattern.sql)

Expect column entries to be strings that match a given SQL `like` pattern.

*Applies to:* Column

```yaml
tests:
  - dbt_expectations.expect_column_values_to_match_like_pattern:
      like_pattern: "%@%"
```

### [expect_column_values_to_not_match_like_pattern](macros/schema_tests/string_matching/expect_column_values_to_not_match_like_pattern.sql)

Expect column entries to be strings that do not match a given SQL `like` pattern.

*Applies to:* Column

```yaml
tests:
  - dbt_expectations.expect_column_values_to_not_match_like_pattern:
      like_pattern: "%&%"
```

### [expect_column_values_to_match_like_pattern_list](macros/schema_tests/string_matching/expect_column_values_to_match_like_pattern_list.sql)

Expect the column entries to be strings that match any of a list of SQL `like` patterns.

*Applies to:* Column

```yaml
tests:
  - dbt_expectations.expect_column_values_to_match_like_pattern_list:
      like_pattern_list: ["%@%", "%&%"]
```

### [expect_column_values_to_not_match_like_pattern_list](macros/schema_tests/string_matching/expect_column_values_to_not_match_like_pattern_list.sql)

Expect the column entries to be strings that do not match any of a list of SQL `like` patterns.

*Applies to:* Column

```yaml
tests:
  - dbt_expectations.expect_column_values_to_not_match_like_pattern_list:
      like_pattern_list: ["%@%", "%&%"]
```

### [expect_column_distinct_count_to_equal](macros/schema_tests/aggregate_functions/expect_column_distinct_count_to_equal.sql)

Expect the number of distinct column values to be equal to a given value.

*Applies to:* Column

```yaml
tests:
  - dbt_expectations.expect_column_distinct_count_to_equal:
      value: 10
```

### [expect_column_distinct_count_to_be_greater_than](macros/schema_tests/aggregate_functions/expect_column_distinct_count_to_be_greater_than.sql)

Expect the number of distinct column values to be greater than a given value.

*Applies to:* Column

```yaml
tests:
  - dbt_expectations.expect_column_distinct_count_to_be_greater_than:
      value: 10
```

### [expect_column_distinct_values_to_be_in_set](macros/schema_tests/aggregate_functions/expect_column_distinct_values_to_be_in_set.sql)

Expect the set of distinct column values to be contained by a given set.

*Applies to:* Column

```yaml
tests:
  - dbt_expectations.expect_column_distinct_values_to_be_in_set:
      value_set: ['a','b','c','d']
```

### [expect_column_distinct_values_to_contain_set](macros/schema_tests/aggregate_functions/expect_column_distinct_values_to_contain_set.sql)

Expect the set of distinct column values to contain a given set.

In contrast to `expect_column_values_to_be_in_set` this ensures not that all column values are members of the given set but that values from the set must be present in the column.

*Applies to:* Column

```yaml
tests:
  - dbt_expectations.expect_column_distinct_values_to_contain_set:
      value_set: ['a','b']
```

### [expect_column_distinct_values_to_equal_set](macros/schema_tests/aggregate_functions/expect_column_distinct_values_to_equal_set.sql)

Expect the set of distinct column values to equal a given set.

In contrast to `expect_column_distinct_values_to_contain_set` this ensures not only that a certain set of values are present in the column but that these and only these values are present.

*Applies to:* Column

```yaml
tests:
  - dbt_expectations.expect_column_distinct_values_to_equal_set:
      value_set: ['a','b','c']
```

### [expect_column_distinct_count_to_equal_other_table](macros/schema_tests/aggregate_functions/expect_column_distinct_count_to_equal_other_table.sql)

Expect the number of distinct column values to be equal to number of distinct values in another model.

*Applies to:* Model, Column, Seed, Source

This can be applied to a model:

```yaml
models: # or seeds:
  - name: my_model_1
    tests:
      - dbt_expectations.expect_column_distinct_count_to_equal_other_table:
          column_name: col_1
          compare_model: ref("my_model_2")
          compare_column_name: col_2
```

or at the column level:

```yaml
models: # or seeds:
  - name: my_model_1
    columns:
      - name: col_1
        tests:
          - dbt_expectations.expect_column_distinct_count_to_equal_other_table:
              compare_model: ref("my_model_2")
              compare_column_name: col_2
```

If `compare_model` or `compare_column_name` are no specified, `model` and `column_name` are substituted. So, one could compare distinct counts of two different columns in the same model, or identically named columns in separate models etc.

### [expect_column_mean_to_be_between](macros/schema_tests/aggregate_functions/expect_column_mean_to_be_between.sql)

Expect the column mean to be between a min_value value and a max_value value (inclusive).

*Applies to:* Column

```yaml
tests:
  - dbt_expectations.expect_column_mean_to_be_between:
      min_value: 0
      max_value: 2
```

### [expect_column_median_to_be_between](macros/schema_tests/aggregate_functions/expect_column_median_to_be_between.sql)

Expect the column median to be between a min_value value and a max_value value (inclusive).

*Applies to:* Column

```yaml
tests:
  - dbt_expectations.expect_column_median_to_be_between:
      min_value: 0
      max_value: 2
```

### [expect_column_quantile_values_to_be_between](macros/schema_tests/aggregate_functions/expect_column_quantile_values_to_be_between.sql)

Expect specific provided column quantiles to be between provided min_value and max_value values.

*Applies to:* Column

```yaml
tests:
  - dbt_expectations.expect_column_quantile_values_to_be_between:
      quantile: .95
      min_value: 0
      max_value: 2
```

### [expect_column_stdev_to_be_between](macros/schema_tests/aggregate_functions/expect_column_stdev_to_be_between.sql)

Expect the column standard deviation to be between a min_value value and a max_value value. Uses sample standard deviation (normalized by N-1).

*Applies to:* Column

```yaml
tests:
  - dbt_expectations.expect_column_stdev_to_be_between:
      min_value: 0
      max_value: 2
```

### [expect_column_stdev_to_be_greater_than](macros/schema_tests/aggregate_functions/expect_column_stdev_to_be_greater_than.sql)

Expect the column standard deviation to be greater than a value and optionally grouped by one or more columns. Uses sample standard deviation (normalized by N-1).

*Applies to:* Column

```yaml
tests:
  - dbt_expectations.expect_column_stdev_to_be_greater_than:
      value: 0
      group_by: ['column_a', 'column_b']
```

### [expect_column_unique_value_count_to_be_between](macros/schema_tests/aggregate_functions/expect_column_unique_value_count_to_be_between.sql)

Expect the number of unique values to be between a min_value value and a max_value value.

*Applies to:* Column

```yaml
tests:
  - dbt_expectations.expect_column_unique_value_count_to_be_between:
      min_value: 3
      max_value: 3
```

### [expect_column_proportion_of_unique_values_to_be_between](macros/schema_tests/aggregate_functions/expect_column_proportion_of_unique_values_to_be_between.sql)

Expect the proportion of unique values to be between a min_value value and a max_value value.

For example, in a column containing [1, 2, 2, 3, 3, 3, 4, 4, 4, 4], there are 4 unique values and 10 total values for a proportion of 0.4.

*Applies to:* Column

```yaml
tests:
  - dbt_expectations.expect_column_proportion_of_unique_values_to_be_between:
      min_value: 0
      max_value: .4
```

### [expect_column_most_common_value_to_be_in_set](macros/schema_tests/aggregate_functions/expect_column_most_common_value_to_be_in_set.sql)

Expect the most common value to be within the designated value set

*Applies to:* Column

```yaml
tests:
  - dbt_expectations.expect_column_most_common_value_to_be_in_set:
      value_set: [0.5]
      top_n: 1
```

### [expect_column_max_to_be_between](macros/schema_tests/aggregate_functions/expect_column_max_to_be_between.sql)

Expect the column max to be between a min and max value

*Applies to:* Column

```yaml
tests:
  - dbt_expectations.expect_column_max_to_be_between:
      min_value: 1
      max_value: 1
```

### [expect_column_min_to_be_between](macros/schema_tests/aggregate_functions/expect_column_min_to_be_between.sql)

Expect the column min to be between a min and max value

*Applies to:* Column

```yaml
tests:
  - dbt_expectations.expect_column_min_to_be_between:
      min_value: 0
      max_value: 1
```

### [expect_column_sum_to_be_between](macros/schema_tests/aggregate_functions/expect_column_sum_to_be_between.sql)

Expect the column to sum to be between a min and max value

*Applies to:* Column

```yaml
tests:
  - dbt_expectations.expect_column_sum_to_be_between:
      min_value: 1
      max_value: 2
```

### [expect_column_pair_values_A_to_be_greater_than_B](macros/schema_tests/multi-column/expect_column_pair_values_A_to_be_greater_than_B.sql)

Expect values in column A to be greater than column B.

*Applies to:* Model, Seed, Source

```yaml
tests:
  - dbt_expectations.expect_column_pair_values_A_to_be_greater_than_B:
      column_A: col_numeric_a
      column_B: col_numeric_a
      or_equal: True
```

### [expect_column_pair_values_to_be_equal](macros/schema_tests/multi-column/expect_column_pair_values_to_be_equal.sql)

Expect the values in column A to be the same as column B.

*Applies to:* Model, Seed, Source

```yaml
tests:
  - dbt_expectations.expect_column_pair_values_to_be_equal:
      column_A: col_numeric_a
      column_B: col_numeric_a
```

### [expect_column_pair_values_to_be_in_set](macros/schema_tests/multi-column/expect_column_pair_values_to_be_in_set.sql)

Expect paired values from columns A and B to belong to a set of valid pairs.

Note: value pairs are expressed as lists within lists

*Applies to:* Model, Seed, Source

```yaml
tests:
  - dbt_expectations.expect_column_pair_values_to_be_in_set:
      column_A: col_numeric_a
      column_B: col_numeric_b
      value_pairs_set: [[0, 1], [1, 0], [0.5, 0.5], [0.5, 0.5]]
```

### [expect_select_column_values_to_be_unique_within_record](macros/schema_tests/multi-column/expect_select_column_values_to_be_unique_within_record.sql)

Expect the values for each record to be unique across the columns listed. Note that records can be duplicated.

*Applies to:* Model, Seed, Source

```yaml
tests:
  - dbt_expectations.expect_select_column_values_to_be_unique_within_record:
      column_list: ["col_string_a", "col_string_b"]
      ignore_row_if: "any_value_is_missing"
```

### [expect_multicolumn_sum_to_equal](macros/schema_tests/multi-column/expect_multicolumn_sum_to_equal.sql)

Expects that sum of all rows for a set of columns is equal to a specific value

*Applies to:* Model, Seed, Source

```yaml
tests:
  - dbt_expectations.expect_multicolumn_sum_to_equal:
      column_list: ["col_numeric_a", "col_numeric_b"]
      sum_total: 4
```

### [expect_compound_columns_to_be_unique](macros/schema_tests/multi-column/expect_compound_columns_to_be_unique.sql)

Expect that the columns are unique together, e.g. a multi-column primary key.

*Applies to:* Model, Seed, Source

```yaml
tests:
  - dbt_expectations.expect_compound_columns_to_be_unique:
      column_list: ["date_col", "col_string_b"]
      ignore_row_if: "any_value_is_missing"
```

### [expect_column_values_to_be_within_n_moving_stdevs](macros/schema_tests/distributional/expect_column_values_to_be_within_n_moving_stdevs.sql)

Expects changes in metric values to be within Z sigma away from a moving average, taking the (optionally logged) differences of an aggregated metric value and comparing it to its value N days ago.

*Applies to:* Column

```yaml
tests:
  - dbt_expectations.expect_column_values_to_be_within_n_moving_stdevs:
      date_column_name: date
      period: day
      lookback_periods: 1
      trend_periods: 7
      test_periods: 14
      sigma_threshold: 3
      take_logs: true
```

### [expect_column_values_to_be_within_n_stdevs](macros/schema_tests/distributional/expect_column_values_to_be_within_n_stdevs.sql)

Expects (optionally grouped & summed) metric values to be within Z sigma away from the column average

*Applies to:* Column

```yaml
tests:
  - dbt_expectations.expect_column_values_to_be_within_n_stdevs:
      group_by: date_day
      sigma_threshold: 3
```
