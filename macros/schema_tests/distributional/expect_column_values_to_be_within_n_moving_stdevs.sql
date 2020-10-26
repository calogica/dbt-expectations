{% macro test_expect_column_values_to_be_within_n_moving_stdevs(model,
                                  column_name,
                                  group_by,
                                  lookback_days=1,
                                  trend_days=7,
                                  test_days=14,
                                  sigma_threshold=3,
                                  take_logs=true
                                ) %}
{#
    This test checks for changes in metric values of more than Z sigma away from a moving average.
    It does this by taking the (optionally logged) differences of an aggregated metric value vs its value N days ago.
    If the the difference value of any tested metric is more than Z sigma away from the moving average, it returns an error.
#}
with grouped_metric_values as (

    select
        {{ group_by }} as metric_date,
        sum({{ column_name }}) as {{ column_name }}_metric_value
    from
        {{ model }}
    group by
        1

),
grouped_metric_values_with_priors as (

    select
        *,
        lag({{ column_name }}_metric_value, {{ lookback_days }}) over(order by metric_date) as {{ column_name }}_prior_metric_value
  from
      grouped_metric_values d

),
metric_diffs as (

    select
        *,
        {%- if take_logs %}
        coalesce(log(nullif({{ column_name }}_metric_value, 0)), 0) -
            coalesce(log(nullif({{ column_name }}_prior_metric_value, 0)), 0) as {{ column_name }}_metric_diff
        {%- else -%}
        coalesce({{ column_name }}_metric_value, 0) -
            coalesce({{ column_name }}_prior_metric_value, 0) as {{ column_name }}_metric_diff
        {%- endif %}
    from
        grouped_metric_values_with_priors d

),
metric_diffs_moving_calcs as (

    select
        *,
        avg({{ column_name }}_metric_diff)
            over(order by metric_date rows
                    between {{ trend_days }} preceding and 1 preceding) as {{ column_name }}_metric_diff_rolling_average,
        stddev({{ column_name }}_metric_diff)
            over(order by metric_date rows
                    between {{ trend_days }} preceding and 1 preceding) as {{ column_name }}_metric_diff_rolling_stddev
    from
        metric_diffs

),
metric_diffs_sigma as (

    select
        *,
        ({{ column_name }}_metric_diff - {{ column_name }}_metric_diff_rolling_average) as {{ column_name }}_metric_diff_delta,
        ({{ column_name }}_metric_diff - {{ column_name }}_metric_diff_rolling_average)/
            {{ column_name }}_metric_diff_rolling_stddev as {{ column_name }}_metric_diff_sigma
    from
        metric_diffs_moving_calcs

)
select
    count(*)
from
    metric_diffs_sigma
where
    metric_date >= date({{ dbt_date.n_days_ago(test_days) }}) and
    metric_date < {{ dbt_date.today() }} and
    abs({{ column_name }}_metric_diff_sigma) > {{ sigma_threshold }}
{%- endmacro -%}
