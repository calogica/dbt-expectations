{%- test expect_table_column_count_to_equal(model, value) -%}
{%- if execute -%}
{%- set number_actual_columns = (dbt_expectations._get_column_list(model) | length) -%}
with test_data as (

    select
        {{ number_actual_columns }} as number_actual_columns,
        {{ value }} as value

)
select *
from test_data
where
    number_actual_columns != value
{%- endif -%}
{%- endtest -%}
