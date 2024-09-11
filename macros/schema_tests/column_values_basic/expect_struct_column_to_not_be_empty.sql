{% test expect_struct_column_to_not_be_empty(model, column_name, row_condition = None) %}

with validation as (

    select {{ column_name }} as array_column
    from {{ model }}
    {%- if row_condition %}
    where
        {{ row_condition }}
    {% endif %}

),

validation_errors as (

    select size(array_column) as metric
    from validation

)
select *
from validation_errors
where
    metric = 0

{% endtest %}