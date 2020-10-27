
{% macro column_pair_values_compare_A_to_B(model, column_A, column_B, operator="=", partition_column=None, partition_filter=None) %}
with validation_errors as (

    select
        {{ column_A }},
        {{ column_B }}
    from
        {{ model }}
    where
        1=1
        {% if partition_column and partition_filter %}
        and {{ partition_column }} {{ partition_filter }}
        {% endif %}
        and
        {{ column_A }} {{ operator }} {{ column_B }}
)

select count(*) from validation_errors

{% endmacro %}