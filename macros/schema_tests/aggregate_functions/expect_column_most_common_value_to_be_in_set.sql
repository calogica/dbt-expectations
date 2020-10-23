{% macro test_expect_column_most_common_value_to_be_in_set(model, values) %}

{% set top_n = kwargs.get('top_n', 1) %}
{% set column_name = kwargs.get('column_name', kwargs.get('field')) %}
{% set quote_values = kwargs.get('quote', True) %}
{% set partition_column = kwargs.get('partition_column', kwargs.get('arg')) %}
{% set partition_filter =  kwargs.get('partition_filter', kwargs.get('arg')) %}

with value_counts as (

    select
        {{ column_name }} as value_field,
        count(*) as value_count

    from {{ model }}
    {% if partition_column and partition_filter %}
    where {{ partition_column }} {{ partition_filter }}
    {% endif %}
    group by 1

),
value_counts_ranked as (

    select 
        *,
        row_number() over(order by value_count desc) as value_count_rank
    from
        value_counts

),
value_count_top_n as (

    select 
        value_field
    from
        value_counts_ranked
    where
        value_count_rank = {{ top_n }}

),
set_values as (

    {% for value in values -%}
    select 
        {% if quote_values -%}
        '{{ value }}'
        {%- else -%}
        {{ value }}
        {%- endif %} as value_field
    {% if not loop.last %}union all{% endif %}
    {% endfor %}

),
unique_set_values as (

    select distinct value_field
    from
        set_values

),
validation_errors as (
    -- values from the model that are not in the set
    select
        v.value_field
    from 
        value_count_top_n v
        left outer join
        unique_set_values s on v.value_field = s.value_field
    where
        v.value_field is null

)

select count(*) as validation_errors
from validation_errors

{% endmacro %}
