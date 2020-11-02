{% macro test_expect_column_values_to_be_increasing(model, column_name, 
                                                   sort_column=None,
                                                   strictly=True,
                                                   partition_column=None,
                                                   partition_filter=None) %}

{%- set sort_column = column_name if not sort_column else sort_column -%}
{%- set operator = ">" if strictly else ">=" %}
with all_values as (

    select
        {{ sort_column }} as sort_column,
        {{ column_name }} as value_field

    from {{ model }}
    {% if partition_column and partition_filter %}
    where {{ partition_column }} {{ partition_filter }}
    {% endif %}

),
add_lag_values as (

    select
        sort_column,
        value_field,
        lag(value_field) over(order by sort_column) as value_field_lag 
    from
        all_values

),
validation_errors as (
 
    select
        *
    from 
        add_lag_values
    where
        value_field_lag is not null 
        and
        not (value_field {{ operator }} value_field_lag)

)
select count(*) as validation_errors
from validation_errors
{% endmacro %}