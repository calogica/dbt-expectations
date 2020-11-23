# dbt-expectations

Extension package for [**dbt**](https://github.com/fishtown-analytics/dbt) inspired by the [Great Expectations package for Python](https://greatexpectations.io/). The intent is to allow dbt users to deploy GE-like tests in their data warehouse directly from dbt, vs having to add another integration with their data warehouse.

## Install

Include in `packages.yml`

```yaml
packages:
  - git: "https://github.com/calogica/dbt-expectations.git"
    revision: <for latest release, see https://github.com/calogica/dbt-expectations/releases>
```

For latest release, see https://github.com/calogica/dbt-expectations/releases

## Dependencies

This package includes a reference to [**dbt-date**](https://github.com/calogica/dbt-date) which in turn references [**dbt-utils**](https://github.com/fishtown-analytics/dbt-utils) so there's no need to also import dbt-utils in your local project.

## Variables

The following variables need to be defined in your `dbt_project.yml` file:

```yaml
vars:
  'dbt_date:time_zone': 'America/Los_Angeles'
```

You may specify [any valid timezone string](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) in place of `America/Los_Angeles`.
For example, use `America/New_York` for East Coast Time.

## Integration Tests

This project contains integration tests for all test macros in a separate `integration_tests` dbt project contained in this repo.

To run the tests:

1. You will need a profile called `integration_tests` in `~/.dbt/profiles.yml` pointing to a writable database.
2. Then, from within the `integration_tests` folder, run `dbt seed` to load `data_test.csv` to the `test` schema of your database.
3. Then run `dbt test` to run the tests specified in `integration_tests/models/schema_tests/schema.yml`

## Macros

### Table shape

#### [expect_column_to_exist](macros/schema_tests/table_shape/expect_column_to_exist.sql)

Expect the specified column to exist.

Usage:
```yaml
tests:
- dbt_expectations.expect_column_to_exist
```

#### [expect_table_column_count_to_be_between](macros/schema_tests/table_shape/expect_table_column_count_to_be_between.sql)

Expect the number of columns in a model to be between two values.

```yaml
tests:
  - dbt_expectations.expect_table_column_count_to_be_between:
      min_value: 1
      max_value: 4
```

#### [expect_table_column_count_to_equal_other_table](macros/schema_tests/table_shape/expect_table_column_count_to_equal_other_table.sql)

Expect the number of columns in a model to match another model.

```yaml
tests:
  - dbt_expectations.expect_table_column_count_to_equal_other_table:
      compare_model: ref("other_model")
```

#### [expect_table_column_count_to_equal](macros/schema_tests/table_shape/expect_table_column_count_to_equal.sql)

Expect the number of columns in a model to be equal to `expected_number_of_columns`.

```yaml
tests:
  - dbt_expectations.expect_table_column_count_to_equal:
      value: 7
```

#### [expect_table_columns_to_match_ordered_list](macros/schema_tests/table_shape/expect_table_columns_to_match_ordered_list.sql)

Expect the columns to exactly match a specified list.

```yaml
tests:
  - dbt_expectations.expect_table_columns_to_match_ordered_list:
      column_list: ["col_a", "col_b"]
```

#### [expect_table_columns_to_match_set](macros/schema_tests/table_shape/expect_table_columns_to_match_set.sql)

Expect the columns in a model to match a given list.

```yaml
tests:
  - dbt_expectations.expect_table_columns_to_match_set:
      column_list: ["col_a", "col_b"]
```

#### [expect_table_row_count_to_be_between](macros/schema_tests/table_shape/expect_table_row_count_to_be_between.sql)

Expect the number of rows in a model to be between two values.

```yaml
tests:
  - dbt_expectations.expect_table_row_count_to_be_between:
      min_value: 1
      max_value: 4
```

#### [expect_table_row_count_to_equal_other_table](macros/schema_tests/table_shape/expect_table_row_count_to_equal_other_table.sql)

Expect the number of rows in a model match another model.

```yaml
tests:
  - dbt_expectations.expect_table_row_count_to_equal_other_table:
      compare_model: ref("other_model")
```

#### [expect_table_row_count_to_equal](macros/schema_tests/table_shape/expect_table_row_count_to_equal.sql)

Expect the number of rows in a model to be equal to `expected_number_of_rows`.

```yaml
tests:
  - dbt_expectations.expect_table_row_count_to_equal_other_table:
      value: 4
```

### Missing values, unique values, and types

#### [expect_column_values_to_be_unique](macros/schema_tests/column_values_basic/expect_column_values_to_be_unique.sql)

Expect each column value to be unique.

```yaml
tests:
  - dbt_expectations.expect_column_values_to_be_unique
```

#### [expect_column_values_to_not_be_null](macros/schema_tests/column_values_basic/expect_column_values_to_not_be_null.sql)

Expect column values to not be null.

```yaml
tests:
  - dbt_expectations.expect_column_values_to_not_be_null
```

#### [expect_column_values_to_be_null](macros/schema_tests/column_values_basic/expect_column_values_to_be_null.sql)

Expect column values to be null.

```yaml
tests:
  - dbt_expectations.expect_column_values_to_be_null
```

#### [expect_column_values_to_be_of_type](macros/schema_tests/column_values_basic/expect_column_values_to_be_of_type.sql)

Expect a column to contain values of a specified data type.

```yaml
tests:
  - dbt_expectations.expect_column_values_to_be_of_type:
      column_type: date
```

#### [expect_column_values_to_be_in_type_list](macros/schema_tests/column_values_basic/expect_column_values_to_be_in_type_list.sql)

Expect a column to contain values from a specified type list.

```yaml
tests:
  - dbt_expectations.expect_column_values_to_be_in_type_list:
      column_type_list: [date, datetime]
```

### Sets and ranges

#### [expect_column_values_to_be_in_set](macros/schema_tests/column_values_basic/expect_column_values_to_be_in_set.sql)

Expect each column value to be in a given set.

```yaml
tests:
  - dbt_expectations.expect_column_values_to_be_in_set:
      value_set: ['a','b','c']
```

#### [expect_column_values_to_be_between](macros/schema_tests/column_values_basic/expect_column_values_to_be_between.sql)

Expect each column value to be between two values.

```yaml
tests:
  - dbt_expectations.expect_column_values_to_be_between:
      min_value: 0
      max_value: 10
```


#### [expect_column_values_to_not_be_in_set](macros/schema_tests/column_values_basic/expect_column_values_to_not_be_in_set.sql)

Expect each column value not to be in a given set.

```yaml
tests:
  - dbt_expectations.expect_column_values_to_not_be_in_set:
      value_set: ['e','f','g']
```

#### [expect_column_values_to_be_increasing](macros/schema_tests/column_values_basic/expect_column_values_to_be_increasing.sql)

Expect column values to be increasing.

If strictly=True, then this expectation is only satisfied if each consecutive value is strictly increasing–equal values are treated as failures.

```yaml
tests:
  - dbt_expectations.expect_column_values_to_be_increasing:
      sort_column: date_day
```

#### [expect_column_values_to_be_decreasing](macros/schema_tests/column_values_basic/expect_column_values_to_be_decreasing.sql)

Expect column values to be decreasing.

If strictly=True, then this expectation is only satisfied if each consecutive value is strictly increasing–equal values are treated as failures.

```yaml
tests:
  - dbt_expectations.expect_column_values_to_be_decreasing:
      sort_column: col_numeric_a
      strictly: false
```

### String matching

#### [expect_column_value_lengths_to_be_between](macros/schema_tests/string_matching/expect_column_value_lengths_to_be_between.sql)

Expect column entries to be strings with length between a min_value value and a max_value value (inclusive).

```yaml
tests:
  - dbt_expectations.expect_column_value_lengths_to_be_between:
      min_value: 1
      max_value: 4
```

#### [expect_column_value_lengths_to_equal](macros/schema_tests/string_matching/expect_column_value_lengths_to_equal.sql)

Expect column entries to be strings with length equal to the provided value.

```yaml
tests:
  - dbt_expectations.expect_column_value_lengths_to_equal:
      value: 10
```

#### [expect_column_values_to_match_regex](macros/schema_tests/string_matching/expect_column_values_to_match_regex.sql)

Expect column entries to be strings that match a given regular expression. Valid matches can be found anywhere in the string, for example "[at]+" will identify the following strings as expected: "cat", "hat", "aa", "a", and "t", and the following strings as unexpected: "fish", "dog".

```yaml
tests:
  - dbt_expectations.expect_column_values_to_match_regex:
      regex: "[at]+"
```


#### [expect_column_values_to_not_match_regex](macros/schema_tests/string_matching/expect_column_values_to_not_match_regex.sql)

Expect column entries to be strings that do NOT match a given regular expression. The regex must not match any portion of the provided string. For example, "[at]+" would identify the following strings as expected: "fish”, "dog”, and the following as unexpected: "cat”, "hat”.

```yaml
tests:
  - dbt_expectations.expect_column_values_to_not_match_regex:
      regex: "[at]+"
```


#### [expect_column_values_to_match_regex_list](macros/schema_tests/string_matching/expect_column_values_to_match_regex_list.sql)

Expect the column entries to be strings that can be matched to either any of or all of a list of regular expressions. Matches can be anywhere in the string.

```yaml
tests:
  - dbt_expectations.expect_column_values_to_match_regex_list:
      regex_list: ["@[^.]*", "&[^.]*"]
```

#### [expect_column_values_to_not_match_regex_list](macros/schema_tests/string_matching/expect_column_values_to_not_match_regex_list.sql)

Expect the column entries to be strings that do not match any of a list of regular expressions. Matches can be anywhere in the string.

```yaml
tests:
  - dbt_expectations.expect_column_values_to_not_match_regex_list:
      regex_list: ["@[^.]*", "&[^.]*"]
```

#### [expect_column_values_to_match_like_pattern](macros/schema_tests/string_matching/expect_column_values_to_match_like_pattern.sql)

Expect column entries to be strings that match a given SQL `like` pattern.

```yaml
tests:
  - dbt_expectations.expect_column_values_to_match_like_pattern:
      like_pattern: "%@%"
```

#### [expect_column_values_to_not_match_like_pattern](macros/schema_tests/string_matching/expect_column_values_to_not_match_like_pattern.sql)

Expect column entries to be strings that do not match a given SQL `like` pattern.

```yaml
tests:
  - dbt_expectations.expect_column_values_to_not_match_like_pattern:
      like_pattern: "%&%"
```


#### [expect_column_values_to_match_like_pattern_list](macros/schema_tests/string_matching/expect_column_values_to_match_like_pattern_list.sql)

Expect the column entries to be strings that match any of a list of SQL `like` patterns.

```yaml
tests:
  - dbt_expectations.expect_column_values_to_match_like_pattern_list:
      like_pattern_list: ["%@%", "%&%"]
```


#### [expect_column_values_to_not_match_like_pattern_list](macros/schema_tests/string_matching/expect_column_values_to_not_match_like_pattern_list.sql)

Expect the column entries to be strings that do not match any of a list of SQL `like` patterns.

```yaml
tests:
  - dbt_expectations.expect_column_values_to_not_match_like_pattern_list:
      like_pattern_list: ["%@%", "%&%"]
```


### Aggregate functions

#### [expect_column_distinct_values_to_be_in_set](macros/schema_tests/aggregate_functions/expect_column_distinct_values_to_be_in_set.sql)

Expect the set of distinct column values to be contained by a given set.

```yaml
tests:
  - dbt_expectations.expect_column_distinct_values_to_be_in_set:
      value_set: ['a','b','c','d']
```

#### [expect_column_distinct_values_to_contain_set](macros/schema_tests/aggregate_functions/expect_column_distinct_values_to_contain_set.sql)

Expect the set of distinct column values to contain a given set.

In contrast to `expect_column_values_to_be_in_set` this ensures not that all column values are members of the given set but that values from the set must be present in the column.

```yaml
tests:
  - dbt_expectations.expect_column_distinct_values_to_contain_set:
      value_set: ['a','b']
```

#### [expect_column_distinct_values_to_equal_set](macros/schema_tests/aggregate_functions/expect_column_distinct_values_to_equal_set.sql)

Expect the set of distinct column values to equal a given set.

In contrast to `expect_column_distinct_values_to_contain_set` this ensures not only that a certain set of values are present in the column but that these and only these values are present.

```yaml
tests:
  - dbt_expectations.expect_column_distinct_values_to_equal_set:
      value_set: ['a','b','c']
```

#### [expect_column_mean_to_be_between](macros/schema_tests/aggregate_functions/expect_column_mean_to_be_between.sql)

Expect the column mean to be between a min_value value and a max_value value (inclusive).

```yaml
tests:
  - dbt_expectations.expect_column_mean_to_be_between:
      min_value: 0
      max_value: 2
```

#### [expect_column_median_to_be_between](macros/schema_tests/aggregate_functions/expect_column_median_to_be_between.sql)

Expect the column median to be between a min_value value and a max_value value (inclusive).

```yaml
tests:
  - dbt_expectations.expect_column_median_to_be_between:
      min_value: 0
      max_value: 2
```

#### [expect_column_quantile_values_to_be_between](macros/schema_tests/aggregate_functions/expect_column_quantile_values_to_be_between.sql)

Expect specific provided column quantiles to be between provided min_value and max_value values.

```yaml
tests:
  - dbt_expectations.expect_column_quantile_values_to_be_between:
      quantile: .95
      min_value: 0
      max_value: 2
```

#### [expect_column_stdev_to_be_between](macros/schema_tests/aggregate_functions/expect_column_stdev_to_be_between.sql)

Expect the column standard deviation to be between a min_value value and a max_value value. Uses sample standard deviation (normalized by N-1).

```yaml
tests:
  - dbt_expectations.expect_column_stdev_to_be_between:
      min_value: 0
      max_value: 2
```

#### [expect_column_unique_value_count_to_be_between](macros/schema_tests/aggregate_functions/expect_column_unique_value_count_to_be_between.sql)

Expect the number of unique values to be between a min_value value and a max_value value.

```yaml
tests:
  - dbt_expectations.expect_column_unique_value_count_to_be_between:
      min_value: 3
      max_value: 3
```


#### [expect_column_proportion_of_unique_values_to_be_between](macros/schema_tests/aggregate_functions/expect_column_proportion_of_unique_values_to_be_between.sql)


Expect the proportion of unique values to be between a min_value value and a max_value value.

For example, in a column containing [1, 2, 2, 3, 3, 3, 4, 4, 4, 4], there are 4 unique values and 10 total values for a proportion of 0.4.

```yaml
tests:
  - dbt_expectations.expect_column_proportion_of_unique_values_to_be_between:
      min_value: 0
      max_value: .4
```

#### [expect_column_most_common_value_to_be_in_set](macros/schema_tests/aggregate_functions/expect_column_most_common_value_to_be_in_set.sql)

Expect the most common value to be within the designated value set

```yaml
tests:
  - dbt_expectations.expect_column_most_common_value_to_be_in_set:
      value_set: [0.5]
      top_n: 1
```

#### [expect_column_max_to_be_between](macros/schema_tests/aggregate_functions/expect_column_max_to_be_between.sql)

Expect the column max to be between a min and max value

```yaml
tests:
  - dbt_expectations.expect_column_max_to_be_between:
      min_value: 1
      max_value: 1
```

#### [expect_column_min_to_be_between](macros/schema_tests/aggregate_functions/expect_column_min_to_be_between.sql)

Expect the column min to be between a min and max value

```yaml
tests:
  - dbt_expectations.expect_column_min_to_be_between:
      min_value: 0
      max_value: 1
```

#### [expect_column_sum_to_be_between](macros/schema_tests/aggregate_functions/expect_column_sum_to_be_between.sql)

Expect the column to sum to be between a min and max value

```yaml
tests:
  - dbt_expectations.expect_column_sum_to_be_between:
      min_value: 1
      max_value: 2
```

### Multi-column

#### [expect_column_pair_values_A_to_be_greater_than_B](macros/schema_tests/multi-column/expect_column_pair_values_A_to_be_greater_than_B.sql)

Expect values in column A to be greater than column B.

```yaml
tests:
  - dbt_expectations.expect_column_pair_values_A_to_be_greater_than_B:
      column_A: col_numeric_a
      column_B: col_numeric_a
      or_equal: True
```

#### [expect_column_pair_values_to_be_equal](macros/schema_tests/multi-column/expect_column_pair_values_to_be_equal.sql)

Expect the values in column A to be the same as column B.

```yaml
tests:
  - dbt_expectations.expect_column_pair_values_to_be_equal:
      column_A: col_numeric_a
      column_B: col_numeric_a
```

#### [expect_column_pair_values_to_be_in_set](macros/schema_tests/multi-column/expect_column_pair_values_to_be_in_set.sql)

Expect paired values from columns A and B to belong to a set of valid pairs.

Note: value pairs are expressed as lists within lists

```yaml
tests:
  - dbt_expectations.expect_column_pair_values_to_be_in_set:
      column_A: col_numeric_a
      column_B: col_numeric_b
      value_pairs_set: [[0, 1], [1, 0], [0.5, 0.5], [0.5, 0.5]]
```


#### [expect_select_column_values_to_be_unique_within_record](macros/schema_tests/multi-column/expect_select_column_values_to_be_unique_within_record.sql)

Expect the values for each record to be unique across the columns listed. Note that records can be duplicated.

```yaml
tests:
  - dbt_expectations.expect_select_column_values_to_be_unique_within_record:
      column_list: ["col_string_a", "col_string_b"]
      ignore_row_if: "any_value_is_missing"
```

#### [expect_multicolumn_sum_to_equal](macros/schema_tests/multi-column/expect_multicolumn_sum_to_equal.sql)

Expects that sum of all rows for a set of columns is equal to a specific value

```yaml
tests:
  - dbt_expectations.expect_multicolumn_sum_to_equal:
      column_list: ["col_numeric_a", "col_numeric_b"]
      sum_total: 4
```

#### [expect_compound_columns_to_be_unique](macros/schema_tests/multi-column/expect_compound_columns_to_be_unique.sql)

Expect that the columns are unique together, e.g. a multi-column primary key.

```yaml
tests:
  - dbt_expectations.expect_compound_columns_to_be_unique:
      column_list: ["date_col", "col_string_b"]
      ignore_row_if: "any_value_is_missing"
```

### Distributional functions

#### [expect_column_values_to_be_within_n_moving_stdevs](macros/schema_tests/distributional/expect_column_values_to_be_within_n_moving_stdevs.sql)

Expects changes in metric values to be within Z sigma away from a moving average, taking the (optionally logged) differences of an aggregated metric value and comparing it to its value N days ago.

```yaml
tests:
  - dbt_expectations.expect_column_values_to_be_within_n_moving_stdevs:
      group_by: date_day
      lookback_days: 1
      trend_days: 7
      test_days: 14
      sigma_threshold: 3
      take_logs: true
```

#### [expect_column_values_to_be_within_n_stdevs](macros/schema_tests/distributional/expect_column_values_to_be_within_n_stdevs.sql)

Expects (optionally grouped & summed) metric values to be within Z sigma away from the column average

```yaml
tests:
  - dbt_expectations.expect_column_values_to_be_within_n_stdevs:
      group_by: date_day
      sigma_threshold: 3
```
