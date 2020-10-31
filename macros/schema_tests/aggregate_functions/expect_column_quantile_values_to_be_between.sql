{% macro test_expect_column_quantile_values_to_be_between(model, column_name,
                                                            quantile,
                                                            minimum,
                                                            maximum,
                                                            partition_column=None,
                                                            partition_filter=None
                                                            ) %}

with column_aggregate as (
 
    select
        {{ dbt_expectations.percentile_cont(column_name, quantile) }} as column_val
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
        (
            column_val < {{ minimum }}
            or 
            column_val > {{ maximum }}
        )
 
    ) validation_errors
{% endmacro %}