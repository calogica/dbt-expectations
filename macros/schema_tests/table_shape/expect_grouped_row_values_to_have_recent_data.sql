{% test expect_grouped_row_values_to_have_recent_data(model,
                                                            group_by,
                                                            timestamp_column,
                                                            datepart,
                                                            interval,
                                                            row_condition=None) %}

 {{ adapter.dispatch('test_expect_grouped_row_values_to_have_recent_data', 'dbt_expectations') (model, group_by, timestamp_column, datepart, interval, row_condition) }}

{% endtest %}

{% macro default__test_expect_grouped_row_values_to_have_recent_data(model, group_by, timestamp_column, datepart, interval, row_condition) %}
with latest_grouped_timestamps as (

    select
        {%- for g in group_by %}
        {{ g }},
        {%- endfor %}
        max({{ timestamp_column }}) as latest_timestamp_column
    from {{ model }}

    {% if row_condition %}
    where {{ row_condition }}
    {% endif %}

    {{ dbt_utils.group_by(group_by | length )}}


),
validation_errors as (

    select *
    from
        latest_grouped_timestamps
    where
        latest_timestamp_column < {{ dbt_utils.dateadd(datepart, interval * -1, dbt_date.now()) }}

)
select * from validation_errors
{% endmacro %}
