{% macro test_expect_column_values_to_be_unique(model, column_name, row_condition=None) %}

with column_values as (

    select
        {{ column_name }} as column_name
    from {{ model }}
    where 1=1
    {% if row_condition %}
        and {{ row_condition }}
    {% endif %}

),
validation_errors as (

    select
        column_name
    from column_values
    group by 1
    having count(*) > 1

)
select count(*) from validation_errors
{% endmacro %}
