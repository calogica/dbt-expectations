{% macro _test_expression_between(model, 
                            expression,
                            minimum,
                            maximum,
                            partition_column=None,
                            partition_filter=None
                            ) %}
with column_aggregate as (
 
    select
        {{ expression }} as column_val
    from 
        {{ model }}
    {% if partition_column and partition_filter %}
    where {{ partition_column }} {{ partition_filter }}
    {% endif %}

)
select count(*)
from (

    select distinct
        column_val
    from 
        column_aggregate
    where 
        not
        (
            column_val >= {{ minimum }}
            and 
            column_val <= {{ maximum }}
        )
 
    ) validation_errors
{% endmacro %}