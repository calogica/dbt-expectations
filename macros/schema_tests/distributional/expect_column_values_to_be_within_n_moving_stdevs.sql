{%- macro _get_metric_expression(metric_column, take_logs) -%}

{%- if take_logs %}
coalesce(log(nullif({{ metric_column }}, 0)), 0)
{%- else -%}
coalesce({{ metric_column }}, 0)
{%- endif %}

{%- endmacro -%}

{% macro test_expect_column_values_to_be_within_n_moving_stdevs(model,
                                  column_name,
                                  group_by,
                                  lookback_days=1,
                                  trend_days=7,
                                  test_days=14,
                                  sigma_threshold=3,
                                  sigma_threshold_upper=None,
                                  sigma_threshold_lower=None,
                                  take_diffs=true,
                                  take_logs=true
                                ) %}

{%- set sigma_threshold_upper = sigma_threshold_upper if sigma_threshold_upper else sigma_threshold -%}
{%- set sigma_threshold_lower = sigma_threshold_lower if sigma_threshold_lower else -1 * sigma_threshold -%}

with metric_values as (

    with grouped_metric_values as (

        select
            {{ group_by }} as metric_date,
            sum({{ column_name }}) as agg_metric_value
        from
            {{ model }}
        group by
            1

    ),
    {%- if take_diffs %}
    grouped_metric_values_with_priors as (

        select
            *,
            lag(agg_metric_value, {{ lookback_days }}) over(order by metric_date) as prior_agg_metric_value
    from
        grouped_metric_values d

    )
    select
        *,
        {{ dbt_expectations._get_metric_expression("agg_metric_value", take_logs) }}
        -
        {{ dbt_expectations._get_metric_expression("prior_agg_metric_value", take_logs) }}
        as metric_test_value
    from
        grouped_metric_values_with_priors d

    {%- else %}

    select
        *,
        {{ dbt_expectations._get_metric_expression("agg_metric_value", take_logs) }}
    from
        grouped_metric_values

    {%- endif %}

),
metric_moving_calcs as (

    select
        *,
        avg(metric_test_value)
            over(order by metric_date rows
                    between {{ trend_days }} preceding and 1 preceding) as metric_test_rolling_average,
        stddev(metric_test_value)
            over(order by metric_date rows
                    between {{ trend_days }} preceding and 1 preceding) as metric_test_rolling_stddev
    from
        metric_values

),
metric_sigma as (

    select
        *,
        (metric_test_value - metric_test_rolling_average) as metric_test_delta,
        (metric_test_value - metric_test_rolling_average)/metric_test_rolling_stddev as metric_test_sigma
    from
        metric_moving_calcs

)
select
    count(*)
from
    metric_sigma
where
    metric_date >= date({{ dbt_date.n_days_ago(test_days) }}) and
    metric_date < {{ dbt_date.today() }} and
    not (
        metric_test_sigma >= {{ sigma_threshold_lower }} and
        metric_test_sigma <= {{ sigma_threshold_upper }}
    )
{%- endmacro -%}
