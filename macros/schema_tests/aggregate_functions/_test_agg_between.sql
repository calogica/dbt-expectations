{% macro _test_agg_between(model, column_name,
                            agg_func,
                            minimum,
                            maximum,
                            partition_column=None,
                            partition_filter=None
                            ) %}
with column_aggregate as (
 
    select
        {{ agg_func }}({{ column_name }}) as column_val
    from 
        {{ model }}
    {% if partition_column and partition_filter %}
    where {{ partition_column }} {{ partition_filter }}
    {% endif %}

)
select count(*)
from (

    select
        column_val
    from 
        column_aggregate
    where 
        (
            column_val < {{ minimum }}
            or 
            column_val > {{ maximum }}
        )
 
    ) validation_errors
{% endmacro %}