# dbt-expectations

Extension package for [**dbt**](https://github.com/fishtown-analytics/dbt) inspired by the [Great Expectations package for Python](https://greatexpectations.io/). The intent is to allow dbt users to deploy GE-like tests in their data warehouse directly from dbt, vs having to add another integration with their data warehouse.

## Install

Include in `packages.yml`

```yaml
packages:
  - git: "git@github.com:calogica/dbt-expectations.git"
    revision: <for latest release, see https://github.com/calogica/dbt-expectations/releases>
```

## Dependdencies
This package includes a reference to [**dbt-data**](https://github.com/calogica/dbt-date) which in turn references [**dbt-utils**](https://github.com/fishtown-analytics/dbt-utils) so there's no need to also import dbt-utils in your local project.

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

[expect_column_to_exist](macros/schema_tests/table_shape/expect_column_to_exist.sql)

[expect_table_column_count_to_be_betweeen](macros/schema_tests/table_shape/expect_table_column_count_to_be_betweeen.sql)

[expect_table_column_count_to_equal_other_table](macros/schema_tests/table_shape/expect_table_column_count_to_equal_other_table.sql)

[expect_table_column_count_to_equal](macros/schema_tests/table_shape/expect_table_column_count_to_equal.sql)

expect_table_columns_to_match_ordered_list

[expect_table_columns_to_match_set](macros/schema_tests/table_shape/expect_table_columns_to_match_set.sql)

[expect_table_row_count_to_be_between](macros/schema_tests/table_shape/expect_table_row_count_to_be_between.sql)

[expect_table_row_count_to_equal_other_table](macros/schema_tests/table_shape/expect_table_row_count_to_equal_other_table.sql)

[expect_table_row_count_to_equal](macros/schema_tests/table_shape/expect_table_row_count_to_equal.sql)


### Missing values, unique values, and types

[expect_column_values_to_be_unique](macros/schema_tests/column_values_basic/expect_column_values_to_be_unique.sql)

[expect_column_values_to_not_be_null](macros/schema_tests/column_values_basic/expect_column_values_to_not_be_null.sql)

[expect_column_values_to_be_null](macros/schema_tests/column_values_basic/expect_column_values_to_be_null.sql)

expect_column_values_to_be_of_type

expect_column_values_to_be_in_type_list

### Sets and ranges

[expect_column_values_to_be_in_set](macros/schema_tests/column_values_basic/expect_column_values_to_be_in_set.sql)

[expect_column_values_to_not_be_in_set](macros/schema_tests/column_values_basic/expect_column_values_to_not_be_in_set.sql)

[expect_column_values_to_be_between](macros/schema_tests/column_values_basic/expect_column_values_to_be_between.sql)

expect_column_values_to_be_increasing

expect_column_values_to_be_decreasing

### String matching

[expect_column_value_lengths_to_be_between](macros/schema_tests/string_matching/expect_column_value_lengths_to_be_between.sql)

[expect_column_value_lengths_to_equal](macros/schema_tests/string_matching/expect_column_value_lengths_to_equal.sql)

expect_column_values_to_match_regex

expect_column_values_to_not_match_regex

expect_column_values_to_match_regex_list

expect_column_values_to_not_match_regex_list

expect_column_values_to_match_like_pattern

expect_column_values_to_not_match_like_pattern

expect_column_values_to_match_like_pattern_list

expect_column_values_to_not_match_like_pattern_list

### Datetime and JSON parsing

~~expect_column_values_to_match_strftime_format~~

~~expect_column_values_to_be_dateutil_parseable~~

expect_column_values_to_be_json_parseable

expect_column_values_to_match_json_schema

### Aggregate functions

[expect_column_distinct_values_to_be_in_set](macros/schema_tests/aggregate_functions/expect_column_distinct_values_to_be_in_set.sql)

[expect_column_distinct_values_to_contain_set](macros/schema_tests/aggregate_functions/expect_column_distinct_values_to_contain_set.sql)

[expect_column_distinct_values_to_equal_set](macros/schema_tests/aggregate_functions/expect_column_distinct_values_to_equal_set.sql)

[expect_column_mean_to_be_between](macros/schema_tests/aggregate_functions/expect_column_mean_to_be_between.sql)

[expect_column_median_to_be_between](macros/schema_tests/aggregate_functions/expect_column_median_to_be_between.sql)

[expect_column_quantile_values_to_be_between](macros/schema_tests/aggregate_functions/expect_column_quantile_values_to_be_between.sql)

[expect_column_stdev_to_be_between](macros/schema_tests/aggregate_functions/expect_column_stdev_to_be_between.sql)

[expect_column_unique_value_count_to_be_between](macros/schema_tests/aggregate_functions/expect_column_unique_value_count_to_be_between.sql)

expect_column_proportion_of_unique_values_to_be_between

[expect_column_most_common_value_to_be_in_set](macros/schema_tests/aggregate_functions/expect_column_most_common_value_to_be_in_set.sql)

[expect_column_max_to_be_between](macros/schema_tests/aggregate_functions/expect_column_max_to_be_between.sql)

[expect_column_min_to_be_between](macros/schema_tests/aggregate_functions/expect_column_min_to_be_between.sql)

[expect_column_sum_to_be_between](macros/schema_tests/aggregate_functions/expect_column_sum_to_be_between.sql)


### Multi-column

expect_column_pair_values_A_to_be_greater_than_B

expect_column_pair_values_to_be_equal

expect_column_pair_values_to_be_in_set

expect_select_column_values_to_be_unique_within_record

expect_multicolumn_sum_to_equal

~~expect_column_pair_cramers_phi_value_to_be_less_than~~

expect_compound_columns_to_be_unique

### Distributional functions

~~expect_column_kl_divergence_to_be_less_than~~

~~expect_column_bootstrapped_ks_test_p_value_to_be_greater_than~~

~~expect_column_chisquare_test_p_value_to_be_greater_than~~

~~expect_column_parameterized_distribution_ks_test_p_value_to_be_greater_than~~