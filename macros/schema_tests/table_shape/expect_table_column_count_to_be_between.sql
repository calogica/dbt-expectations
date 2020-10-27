{%- macro test_expect_table_column_count_to_be_between(model) -%}
{% set minimum = kwargs.get('minimum', 0) %}
{% set maximum = kwargs.get('maximum', kwargs.get('arg')) %}

{%- set number_actual_columns = (adapter.get_columns_in_relation(model) | length) -%}
select 
    case
        when {{ number_actual_columns >= minimum and number_actual_columns <= maximum }} 
        then 0 else 1
    end
{%- endmacro -%}