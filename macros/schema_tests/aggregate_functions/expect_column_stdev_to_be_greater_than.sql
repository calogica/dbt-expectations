{% macro test_expect_column_stdev_to_be_greater_than(model, column_name,
                                                    greater_than_value,
                                                    group_by=None,
                                                    row_condition=None
                                                    ) -%}
    {{ adapter.dispatch('test_expect_column_stdev_to_be_greater_than', 
        packages = dbt_expectations._get_namespaces()) (model, column_name,
                                                    greater_than_value,
                                                    group_by,
                                                    row_condition
                                                    ) }}
{%- endmacro %}

{% macro default__test_expect_column_stdev_to_be_greater_than(model, column_name,
                                                    greater_than_value,
                                                    group_by,
                                                    row_condition
                                                 ) %}
with calc as (
    select distinct
        {% if group_by %}
            {{ group_by | join(', ') }},
            stddev({{ column_name }}) over (
                partition by {{ group_by | join(', ') }}
            )
        {% else %}
            stddev({{ column_name }})
        {% endif -%}

        as {{ column_name }}_stddev

    from {{ model }}

),

validation_errors as (
    select * from calc where {{ column_name }}_stddev <= {{ greater_than_value }}
)

select count(*) from validation_errors
    
{% endmacro %}