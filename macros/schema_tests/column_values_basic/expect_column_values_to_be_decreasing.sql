{% test expect_column_values_to_be_decreasing(model, column_name,
                                                   sort_column=None,
                                                   strictly=True,
                                                   row_condition=None,
                                                   partition_columns=None) %}

{%- set sort_column = column_name if not sort_column else sort_column -%}
{%- set operator = "<" if strictly else "<=" %}
{%- set partition_columns_list = partition_columns.split(',') %}
with all_values as (

    select
        {{ sort_column }} as sort_column,
        {{ column_name }} as value_field
        {%- if partition_columns -%}
            {%- for columns in partition_columns_list -%}
        , {{ columns }}
            {%- endfor -%}
        {%- endif %}
    from {{ model }}
    {% if row_condition %}
    where {{ row_condition }}
    {% endif %}

),
add_lag_values as (

    select
        sort_column,
        value_field,
        lag(value_field) over
            {%- if not partition_columns -%}
                (order by sort_column)
            {%- else -%}
                (partition by {{ partition_columns }} order by sort_column)
            {%- endif -%}    as value_field_lag    
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
select *
from validation_errors
{% endtest %}
