{% test expect_grouped_row_values_to_have_recent_data(model,
                                                        group_by,
                                                        timestamp_column,
                                                        datepart,
                                                        interval,
                                                        row_condition=None) %}

 {{ adapter.dispatch('test_expect_grouped_row_values_to_have_recent_data', 'dbt_expectations') (model,
                                                                                                group_by,
                                                                                                timestamp_column,
                                                                                                datepart,
                                                                                                interval,
                                                                                                row_condition) }}

{% endtest %}

{% macro default__test_expect_grouped_row_values_to_have_recent_data(model,
                                                                        group_by,
                                                                        timestamp_column,
                                                                        datepart,
                                                                        interval,
                                                                        row_condition) %}
with latest_grouped_timestamps as (

    select
        {%- for g in group_by %}
        {{ g }},
        {%- endfor %}
        max(1) as join_key,
        max(cast({{ timestamp_column }} as {{ dbt_utils.type_timestamp() }})) as latest_timestamp_column
    from
        {{ model }}
    where
        -- to exclude erroneous future dates
        cast({{ timestamp_column }} as {{ dbt_utils.type_timestamp() }}) <= {{ dbt_date.now() }}
        {% if row_condition %}
        and {{ row_condition }}
        {% endif %}

    {{ dbt_utils.group_by(group_by | length )}}

),
total_row_counts as (

    select
        max(1) as join_key,
        count(*) as row_count
    from
        latest_grouped_timestamps

),
outdated_grouped_timestamps as (

    select *
    from
        latest_grouped_timestamps
    where
        -- are the max timestamps per group older than the specified cutoff?
        latest_timestamp_column <
            cast(
                {{ dbt_utils.dateadd(datepart, interval * -1, dbt_date.now()) }}
                as {{ dbt_utils.type_timestamp() }}
            )

),
validation_errors as (

    select
        r.row_count,
        t.*
    from
        total_row_counts r
        left join
        outdated_grouped_timestamps t
        on r.join_key = t.join_key
    where
        -- fail if either no rows were returned due to row_condition,
        -- or the recency test returned failed rows
        r.row_count = 0
        or
        t.join_key is not null

)
select * from validation_errors
{% endmacro %}
