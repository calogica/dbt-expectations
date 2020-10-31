{% macro test_expect_column_unique_value_count_to_be_between(model, column_name,
                                                            quantile,
                                                            minimum,
                                                            maximum,
                                                            partition_column=None,
                                                            partition_filter=None
                                                            ) %}
with column_aggregate as (
 
    select
        count(distinct {{ column_name }}) as value_count
    from 
        {{ model }}
    {% if partition_column and partition_filter %}
    where {{ partition_column }} {{ partition_filter }}
    {% endif %}

)
select count(*)
from (

    select
        value_count
    from 
        column_aggregate
    where 
        (
            value_count < {{ minimum }}
            or 
            value_count > {{ maximum }}
        )
 
    ) validation_errors
{% endmacro %}