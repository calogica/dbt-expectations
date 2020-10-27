
{% macro test_expect_column_pair_values_A_to_be_greater_than_B(model, column_A, column_B, or_equal=None) %}
{% set partition_column = kwargs.get('partition_column', kwargs.get('arg')) %}
{% set partition_filter =  kwargs.get('partition_filter', kwargs.get('arg')) %}
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
        {{ column_A }}
        {%- if or_equal %} < {% else %} <= {% endif -%}
        {{ column_B }}
)

select count(*) from validation_errors

{% endmacro %}