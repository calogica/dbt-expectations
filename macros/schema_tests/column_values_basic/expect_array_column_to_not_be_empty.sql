{% test expect_array_column_to_not_be_empty(model, column_name, row_condition = None) %}

with validation as (

    select {{ column_name }} as array_column
    from {{ model }}
    {%- if row_condition %}
    where
        {{ row_condition }}
    {% endif %}

),

validation_errors as (

    select array_contains(array_column, '') as metric_1,
           size(array_column) as metric_2
    from validation

)
select *
from validation_errors
where
    metric_1 = True
    or metric_2 = 0

{% endtest %}