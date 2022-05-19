{%- test expect_table_column_count_to_equal_other_table(model, compare_model) -%}
{%- if execute -%}
{%- set number_columns = (dbt_expectations._get_column_list(model) | length) -%}
{%- set compare_number_columns = (dbt_expectations._get_column_list(compare_model) | length) -%}
with test_data as (

    select
        {{ number_columns }} as number_columns,
        {{ compare_number_columns }} as compare_number_columns

)
select *
from test_data
where
    number_columns != compare_number_columns
{%- endif -%}
{%- endtest -%}
