{% macro test_expression_between(model,
                                 expression,
                                 min_value,
                                 max_value,
                                 partition_column=None,
                                 partition_filter=None
                                 ) %}

    {{ dbt_expectations.expression_between(model, expression, min_value, max_value, partition_column, partition_filter) }}

{% endmacro %}

{% macro expression_between(model,
                            expression,
                            min_value,
                            max_value,
                            partition_column=None,
                            partition_filter=None
                            ) %}
with column_expression as (

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
        column_expression
    where
        not
        (
            column_val >= {{ min_value }}
            and
            column_val <= {{ max_value }}
        )

    ) validation_errors
{% endmacro %}
