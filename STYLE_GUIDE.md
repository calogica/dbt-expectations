# dbt-expectations Style Guide

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
    orders.order_item_id,
    orders.product_id,
    accounts.account_id,
    accounts...,
    ...
from
    fct_order_items orders
    inner join dim_account accounts on orders.account_id = accounts.account_id
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
        order_items
        inner join accounts
            on oder_items.account_id = accounts.account_id

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
    inner join dimension_table d on f.id = d.id
```

For joins with multiple columns we break up long statements

```sql
select
...
from
    fact_table f
    inner join relationship_table r
        on f.id = r.id and
            f.other_id = d.other_id
```

`inner join` statements preceed any outer or full join statements

```sql
select
...
from
    fact_table f
    inner join dimension_table d on f.id = d.id
    left join other_dimension_table o on f.id = o.id
```

### Grouping

We group using ordinal references to columns. For clarity, we try to limit `group by` statements to no more than 2 or 3 columns. The grouping should reflect the true intended granularity of the statement.

*Example:*
We aggregate `account_city_name` via `max()` to make it clear that the granularity of this statement is `account_id` + `product_id`

```sql
select
    orders.account_id,
    orders.product_id,
    max(account.account_city_name) as account_city_name,
    sum(orders.order_item_count) as order_item_count
from
    fct_order_items orders
    inner join dim_account account
        on orders.account_id = account.account_id
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
