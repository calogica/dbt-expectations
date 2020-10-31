{% macro test_expect_column_median_to_be_between(model, column_name,
                                                    minimum,
                                                    maximum,
                                                    partition_column=None,
                                                    partition_filter=None
                                                    ) %}
with column_aggregate as (
 
    select
        {{ dbt_expectations.median(column_name) }} as column_val
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