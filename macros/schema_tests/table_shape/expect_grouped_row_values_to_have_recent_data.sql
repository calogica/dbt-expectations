{% macro test_expect_grouped_row_values_to_have_recent_data(model, group_by, timestamp_column, datepart, interval) %}
with latest_grouped_timestamps as (

    select
        {%- for g in group_by %}
        {{ g }},
        {%- endfor %}
        max({{ timestamp_column }}) as latest_timestamp_column
    from
        {{ model }}
    {{ dbt_utils.group_by(group_by | length )}}

),
validation_errors as (

    select *
    from
        latest_grouped_timestamps
    where
        latest_timestamp_column < {{ dbt_utils.dateadd(datepart, interval * -1, dbt_date.now()) }}

)
select count(*) from validation_errors
{% endmacro %}
