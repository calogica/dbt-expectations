# Calogica Style Guide

## Model Names

We organize the dbt project DAG in the following layers:

```yaml
source **
    --> staging *
        --> transform *
            --> dw
                --> xa

**  not dbt-managed
*   private models
```

For private models (staging, transform), we have more flexibility with respect to names, since we don't expose these models to our "public" data warehouse users.

For models in the `_staging` and `_transform` folders, we follow these conventions:

### Staging Models

`stg_<entity>.sql` where `entity` should be as close to the source table as possible,
*Example*: `stg_products.sql` is a staging model for the `products` source table.

We use staging models mostly for column renames and data types changes to provide a clean interface to a source table. We use the `dbt_utils.types()` macro to abstract data types for type conversions.

### Transform Models

Transform models implement the bulk of the business logic and can use either `stg` or other `tf_*` models as upstream sources. The `entity` should represent the main entity, grouping level or combination of entities from the model.

`tf_<entity>.sql`

*Example*:
`tf_events.sql`
`tf_order_items.sql`

### DW Models

For models we expose as the query API to data consumers (i.e. those in the `dw` folder and subfolders), we follow star schema naming conventions, with *prefixes* denoting the type of model.

#### Fact Models

fct_`<entity>.sql` (where `entity` is the **plural** of the fact we're modeling)

*Example:* `fct_events.sql`

#### Dimension Models

`dim_<entity>.sql` (where `entity` is the **singular** of the dimension we're modeling)

*Example:* `dim_product.sql`

#### Relationship Models

Dimension models that represent a relationship between entities contain more than one column in the key, i.e. they require a multi-column join, so we make it clear that they are special by using the `xrf_` prefix.

`xrf_<entity>_<entity>.sql` (where `entity` is the **singular** of the dimension we're modeling)

*Example:*
`xrf_account_day.sql`
`xrf_user_device.sql`

### XA Models

`XA` models represent `eXtended Aggregates`, which we use to either aggregate a more granular model for performance benefits, or to model the relationship between a number of fact and dimension models, or both,

We source `XA` models exclusively from `fct_`, `dim_` or other `xa_` models.

*Example:*
`xa_account_day.sql`
`xa_purchase_conversions.sql`

## Column Names

We use lower-case `snake_case` for all column names. Column names should make intuitive sense to a domain-aware users of the model. As such, we do not abbreviate columns, unless the abbreviation is commonly accepted.

We also follow a data-type specific set of conventions to make it clear what kind of data a query user might expect, before querying data.

```
------
DON'T:
------
pmt_amt
subscriber_cnt
universal_resource_locator_name
------
DO:
------
payment_amount
subscriber_count
url
```

### Boolean

Depending on context:

`is_<column_name>` or `has_<column_name>`

Where `<column_name>` is the **positive** case of the boolean.

*Example:*

```
is_subscriber_on_date
has_session_on_date
```

### Numeric

- Dimension column representing integer ID

    `<column>_id`

- Dimension column representing integer sequence number

    `<column>_sequence_number`

- Fact column representing count

    `<column>_count`

- Fact column representing float/decimal amount

    `<column>_amount` or
    `<column>_<units>`

    Example:

    ```
    sales_amount
    wait_time_milliseconds
    ```

### Timestamp / Date

- UTC Timestamp

    `<column>_timestamp_utc`

- PST Timestamp

    `<column>_timestamp_pst`

- Localized Timestamp

    `<column>_timestamp_local`

- UTC Date

    `<column>_date_utc`

- PST Date

    `<column>_date_pst`

- Localized Date

    `<column>_date_local`

### String

- Source-generated character UUID of a dimension attribute

    `<column>_id`

- Data Warehouse-generated character UUID of a dimension attribute (surrogate key)

    `<column>_key`

- Name of a dimension attribute

    `<column>_name`

- Human-readable short code of a dimension attribute

    `<column>_code`

## Null, Unknown or Missing Values

We avoid `null` values wherever possible, since they present a number of challenges to both query writers and business users.

We treat `null` values depending on the situation or type of missingness:

- **Not Applicable**: the column does not apply to this row

- **Missing**: column value *should* be present, but is missing from source data

- **Unknown**: source column value is not known to data warehouse (this should only be used if we want to suppress noisy source data, but draw attention to it in aggregate; otherwise replace with sensible default)

```
|                                                    | Not Applicable |   Missing |   Unknown |
|----------------------------------------------------|---------------:|----------:|----------:|
| Boolean                                            |         false* |    false* |    false* |
| Integer ID                                         |          -1001 |     -1002 |     -1003 |
| Integer sequence number                            |          -1001 |     -1002 |     -1003 |
| Integer count                                      |              0 |         0 |         0 |
| Float/decimal amount                               |           0.00 |      0.00 |      0.00 |
| UTC/PST/Local Timestamp                            |          null* |     null* |     null* |
| UTC/PST/Local Date                                 |          null* |     null* |     null* |
| Source-generated UUID                              |          (N/A) | (Missing) | (Unknown) |
| Data Warehouse-generated UUID                      |          (N/A) | (Missing) | (Unknown) |
| Name of a dimension attribute                      |          (N/A) | (Missing) | (Unknown) |
| Human-readable short code of a dimension attribute |          (N/A) | (Missing) | (Unknown) |

                                                        * or context-driven sensible default
```

## SQL Style Guide

When writing SQL, we adhere to the following conventions to provide a consistent experience for developers within the project. In code reviews we highlight formatting issues as part of the final review once all business logic feedback has been resolved.

As a general principle for code style we prefer **explicit** over implicit. Instead of writing overly concise statements, we prefer explicitly stating intent in code and naming of variables. Often this requires us to break up an elegant and concise construct only the original developer would really understand in the future, into multiple building blocks that the next developer (or the future You) can more easily follow.

*Example:*

Bad:

```sql
greatest(n-6, n)
```

Better:

```sql
case
    when
        number_of_days > 6 then
        number_of_days - 6
    else
        number_of_days
end
```

Great:

```sql
{%- set minimum_days = 3 %-}
{%- set minimum_length_stay = 2*minimum_days %-}
case
    when
        number_of_days > {{ minimum_length_stay }} then
        number_of_days - {{ minimum_length_stay }}
    else
        number_of_days
end
```

### Formatting

#### Casing

We write all SQL code in `lower case`. This includes keywords, table and column references and aliases.

#### Indenting/Spacing

- We use **4 spaces** for indents
  - Use the `EditorConfig` extension for VS Code to make this seamless
  - The `.editorconfig` file in this project controls project wide preferences for this extension
  - This extension will also remove **trailing whitespace** and insert a **new line at the end of each file**
- We use white space liberally and deliberately
- We optimize indenting and spacing for **readability**, not conciseness

### Magic Numbers

We avoid "magic numbers" and instead explicitly set constants in models via Jinja variables.

*Example:*

```sql
{%- set minimum_length = 7 %-}
```

Then use and re-use:

```sql
where
    number_of_days >= {{ minimum_length }}
```

### Column Aliasing

We try to be as descriptive as possible for column aliases for intermediate columns and avoid abbreviations or short codes. For column aliases for output columns we follow our column naming outlined above.

### Table Aliasing

We alias references to tables in the `from` clause if more than one table is involved, using easy to follow but not overly verbose aliases. In most cases, we use single letter aliases.

Once a table is aliased, we use fully-qualified references for all columns to avoid confusion and/or potential collision.

*Example:*

```sql
select
    o.order_item_id,
    o.product_id,
    a.account_id,
    a.gender_name,
    ...
from
    fct_order_items o
    inner join
    dim_account a
        on o.account_id = a.account_id
```

### CTEs

We use CTEs (Common Table Expressions) instead of subqueries. We break up long SQL statements wherever possible into multiple CTEs to improve clarity and readability and to make refactoring easier.

In addition, we "import" all upstream dbt models used in the current model at the top of the model using single-line compact CTEs. This helps other developers understand upstream dependencies without having to scan the entire model for `ref` statements.

*Example*:

```sql
with order_items as (
    select * from {{ ref('fct_order_items') }}
),
accounts as (
    select * from {{ ref('dim_account') }}
),
accounts_with_order_items as (

    select
    ...
    from
        order_items o
        inner join
        accounts a on o.account_id = a.account_id

)
```

### Joins

We use **explicit** joins in nature and direction and **only** use:

- `inner join` **not** `join`
- `left join`
- `full join`
- `cross join` **not** `,` (comma cross join)

There is no `right join`.

We write joins using the "big table first" approach, so we reference the bigger table (e.g. a fact) before smaller (e.g. dimension) tables.

Joins are *part* of the `from` clause, so we indent everything related to `join` under the `from` clause.

*Example:*

```sql
select
...
from
    fact_table f
    inner join
    dimension_table d
        on f.id = d.id
```

For joins with multiple columns we break up long statements

```sql
select
...
from
    fact_table f
    inner join
    relationship_table r
        on f.id = r.id and
            f.other_id = d.other_id
```

`inner join` statements preceed any outer or full join statements

```sql
select
...
from
    fact_table f
    inner join
    dimension_table d
        on f.id = d.id
    left join
    other_dimension_table o
        on f.id = o.id
```

### Grouping

We group using ordinal references to columns. For clarity, we try to limit `group by` statements to no more than 2 or 3 columns. The grouping should reflect the true intended granularity of the statement.

*Example:*
We aggregate `account_city_name` via `max()` to make it clear that the granularity of this statement is `account_id` - `product_id`

```sql
select
    o.account_id,
    o.product_id,
    max(a.account_city_name) as account_city_name,
    sum(p.order_item_count) as order_item_count
from
    fct_order_items o
    inner join
    dim_account a on o.account_id = a.account_id
group by
    1, 2
```

## Jinja Style Guide

We follow Python naming conventions and style norms for all Jinja code.

### Macro Names

We use lower-case `snake_case` for macro names that clearly state the unit of work the macro encompasses.

In most cases, we write one macro per file, which we name `<macro_name>.sql`.

Example:

```python
make_age_groups.sql

{% macro make_age_groups(as_of_date) -%}
...
{%- endmacro %}
```

In the case of **test** macros, we use the first-level `test` object available since dbt 0.20.x instead of the older style `macro test_<test_name>` syntax.

```python
not_null.sql

{% test not_null(model) %}
...
{% endmacro %}
```

### Whitespace control

We make sure to employ Jinja whitespace control to make sure runtime SQL is readable.

We do this by setting the Jinja whitespace characters for control flow statements, `{%-` vs simply `{%` and `-%}` vs simply `%}` where appropriate.

```python
{% for age_group in age_groups -%}
    when {{ dbt_date.date_part('year', as_of_date) }} - birth_year
        between {{ age_group["start"] }} and {{ age_group["end"] }}
        then {{ age_group["id"] }}
{% endfor -%}
```

results in:

```sql
...
when extract(year from date_pst) - birth_year
        between 0 and 17
        then 1
when extract(year from date_pst) - birth_year
        between 18 and 24
        then 2
...
```
