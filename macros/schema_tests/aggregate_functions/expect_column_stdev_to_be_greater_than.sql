{% macro test_expect_column_stdev_to_be_greater_than(model, 
                                                     column_name,
                                                     value,
                                                     group_by=None,
                                                     row_condition=None) -%}

    {{ adapter.dispatch('test_expect_column_stdev_to_be_greater_than', 
        packages = dbt_expectations._get_namespaces()) (model, 
                                                        column_name,
                                                        value,
                                                        group_by,
                                                        row_condition) }}
{%- endmacro %}

{% macro default__test_expect_column_stdev_to_be_greater_than(model, 
                                                              column_name,
                                                              value,
                                                              group_by,
                                                              row_condition) %}

with calc as (
    select
        {% if group_by %}
            {{ group_by | join(', ') }},
        {% endif -%}
            stddev({{ column_name }}) as {{ column_name }}_stddev

    from {{ model }}

    {% if group_by %}
    group by {{ group_by | join(', ') }}
    {% endif %}

),

validation_errors as (
    select * from calc where {{ column_name }}_stddev <= {{ value }}
)

select count(*) from validation_errors
    
{% endmacro %}