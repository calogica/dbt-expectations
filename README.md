# dbt-expectations

Extension package for [**dbt**](https://github.com/fishtown-analytics/dbt) inspired by Great Expectations.

FYI: this package includes [**dbt-utils**](https://github.com/fishtown-analytics/dbt-utils) so there's no need to also import dbt-utils in your local project.

Include in `packages.yml`

```
packages:
  - git: "git@github.com:calogica/dbt-test.git"
    revision: <for latest release, see https://github.com/calogica/dbt-test/releases>
```

## Variables
The following variables need to be defined in your `dbt_project.yml` file:

`'dbt_date:time_zone': 'America/Los_Angeles'`

You may specify [any valid timezone string](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) in place of `America/Los_Angeles`.
For example, use `America/New_York` for East Coast Time.

## Macros

TODO