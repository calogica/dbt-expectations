# dbt-expectations

Extension package for [**dbt**](https://github.com/fishtown-analytics/dbt) inspired by the [Great Expectations package for Python](https://greatexpectations.io/). The intent is to allow dbt users to deploy GE-like tests in their data warehouse directly from dbt, vs having to add another integration with their data warehouse.

## Install

Include in `packages.yml`

```yaml
packages:
  - git: "git@github.com:calogica/dbt-expectations.git"
    revision: <for latest release, see https://github.com/calogica/dbt-expectations/releases>
```

## Dependencies

This package includes a reference to [**dbt-date**](https://github.com/calogica/dbt-date) which in turn references [**dbt-utils**](https://github.com/fishtown-analytics/dbt-utils) so there's no need to also import dbt-utils in your local project.

Note: **dbt-date** is currently in the process of being upgraded to dbt 0.18+, which will remove the current deprecation warnings.

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

#### [expect_table_column_count_to_be_betweeen](macros/schema_tests/table_shape/expect_table_column_count_to_be_betweeen.sql)

Expect the number of columns in a model to be between two values.

```yaml
tests:
  - dbt_expectations.expect_table_column_count_to_be_betweeen:
      minimum: 1
      maximum: 4
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
      expected_number_of_columns: 7
```

#### expect_table_columns_to_match_ordered_list

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
      minimum: 1
      maximum: 4
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
      expected_number_of_rows: 4
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

#### expect_column_values_to_be_of_type

#### expect_column_values_to_be_in_type_list

### Sets and ranges

#### [expect_column_values_to_be_in_set](macros/schema_tests/column_values_basic/expect_column_values_to_be_in_set.sql)

Expect each column value to be in a given set.

```yaml
tests:
  - dbt_expectations.expect_column_values_to_be_in_set:
      values: ['a','b','c']
```

#### [expect_column_values_to_be_between](macros/schema_tests/column_values_basic/expect_column_values_to_be_between.sql)

Expect each column value to be between two values.

```yaml
tests:
  - dbt_expectations.expect_column_values_to_be_between:
      minimum: 0
      maximum: 10
```


#### [expect_column_values_to_not_be_in_set](macros/schema_tests/column_values_basic/expect_column_values_to_not_be_in_set.sql)

Expect each column value not to be in a given set.

```yaml
tests:
  - dbt_expectations.expect_column_values_to_not_be_in_set:
      values: ['e','f','g']
```

#### expect_column_values_to_be_increasing

#### expect_column_values_to_be_decreasing

### String matching

#### [expect_column_value_lengths_to_be_between](macros/schema_tests/string_matching/expect_column_value_lengths_to_be_between.sql)

Expect column entries to be strings with length between a minimum value and a maximum value (inclusive).

```yaml
tests:
  - dbt_expectations.expect_column_value_lengths_to_be_between:
      minimum_length: 1
      maximum_length: 4
```

#### [expect_column_value_lengths_to_equal](macros/schema_tests/string_matching/expect_column_value_lengths_to_equal.sql)

Expect column entries to be strings with length equal to the provided value.

```yaml
tests:
  - dbt_expectations.expect_column_value_lengths_to_equal:
      length: 10
```

#### expect_column_values_to_match_regex

#### expect_column_values_to_not_match_regex

#### expect_column_values_to_match_regex_list

#### expect_column_values_to_not_match_regex_list

#### expect_column_values_to_match_like_pattern

#### expect_column_values_to_not_match_like_pattern

#### expect_column_values_to_match_like_pattern_list

#### expect_column_values_to_not_match_like_pattern_list

### Aggregate functions

#### [expect_column_distinct_values_to_be_in_set](macros/schema_tests/aggregate_functions/expect_column_distinct_values_to_be_in_set.sql)

Expect the set of distinct column values to be contained by a given set.

```yaml
tests:
  - dbt_expectations.expect_column_distinct_values_to_be_in_set:
      values: ['a','b','c','d']
```

#### [expect_column_distinct_values_to_contain_set](macros/schema_tests/aggregate_functions/expect_column_distinct_values_to_contain_set.sql)

Expect the set of distinct column values to contain a given set.

In contrast to `expect_column_values_to_be_in_set` this ensures not that all column values are members of the given set but that values from the set must be present in the column.

```yaml
tests:
  - dbt_expectations.expect_column_distinct_values_to_contain_set:
      values: ['a','b']
```

#### [expect_column_distinct_values_to_equal_set](macros/schema_tests/aggregate_functions/expect_column_distinct_values_to_equal_set.sql)

Expect the set of distinct column values to equal a given set.

In contrast to `expect_column_distinct_values_to_contain_set` this ensures not only that a certain set of values are present in the column but that these and only these values are present.

```yaml
tests:
  - dbt_expectations.expect_column_distinct_values_to_equal_set:
      values: ['a','b','c']
```

#### [expect_column_mean_to_be_between](macros/schema_tests/aggregate_functions/expect_column_mean_to_be_between.sql)

Expect the column mean to be between a minimum value and a maximum value (inclusive).

```yaml
tests:
  - dbt_expectations.expect_column_mean_to_be_between:
      minimum: 0
      maximum: 2
```

#### [expect_column_median_to_be_between](macros/schema_tests/aggregate_functions/expect_column_median_to_be_between.sql)

Expect the column median to be between a minimum value and a maximum value (inclusive).

```yaml
tests:
  - dbt_expectations.expect_column_median_to_be_between:
      minimum: 0
      maximum: 2
```

#### [expect_column_quantile_values_to_be_between](macros/schema_tests/aggregate_functions/expect_column_quantile_values_to_be_between.sql)

Expect specific provided column quantiles to be between provided minimum and maximum values.

```yaml
tests:
  - dbt_expectations.expect_column_quantile_values_to_be_between:
      quantile: .95
      minimum: 0
      maximum: 2
```

#### [expect_column_stdev_to_be_between](macros/schema_tests/aggregate_functions/expect_column_stdev_to_be_between.sql)

Expect the column standard deviation to be between a minimum value and a maximum value. Uses sample standard deviation (normalized by N-1).

```yaml
tests:
  - dbt_expectations.expect_column_stdev_to_be_between:
      minimum: 0
      maximum: 2
```

#### [expect_column_unique_value_count_to_be_between](macros/schema_tests/aggregate_functions/expect_column_unique_value_count_to_be_between.sql)

Expect the number of unique values to be between a minimum value and a maximum value.

```yaml
tests:
  - dbt_expectations.expect_column_unique_value_count_to_be_between:
      minimum: 3
      maximum: 3
```


#### expect_column_proportion_of_unique_values_to_be_between

#### [expect_column_most_common_value_to_be_in_set](macros/schema_tests/aggregate_functions/expect_column_most_common_value_to_be_in_set.sql)

Expect the most common value to be within the designated value set

```yaml
tests:
  - dbt_expectations.expect_column_most_common_value_to_be_in_set:
      values: [0.5]
      top_n: 1
```

#### [expect_column_max_to_be_between](macros/schema_tests/aggregate_functions/expect_column_max_to_be_between.sql)

Expect the column max to be between an min and max value

```yaml
tests:
  - dbt_expectations.expect_column_max_to_be_between:
      minimum: 1
      maximum: 1
```

#### [expect_column_min_to_be_between](macros/schema_tests/aggregate_functions/expect_column_min_to_be_between.sql)

Expect the column min to be between an min and max value

```yaml
tests:
  - dbt_expectations.expect_column_min_to_be_between:
      minimum: 0
      maximum: 1
```

#### [expect_column_sum_to_be_between](macros/schema_tests/aggregate_functions/expect_column_sum_to_be_between.sql)

Expect the column to sum to be between an min and max value

```yaml
tests:
  - dbt_expectations.expect_column_sum_to_be_between:
      minimum: 1
      maximum: 2
```

### Multi-column

expect_column_pair_values_A_to_be_greater_than_B

expect_column_pair_values_to_be_equal

expect_column_pair_values_to_be_in_set

expect_select_column_values_to_be_unique_within_record

expect_multicolumn_sum_to_equal

expect_compound_columns_to_be_unique

### Distributional functions
