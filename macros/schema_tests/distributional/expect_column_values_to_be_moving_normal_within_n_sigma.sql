{% macro test_expect_column_values_to_be_moving_normal_within_n_sigma(model,
                                  columns,
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
        {%- for column in columns %}
        sum({{ column }}) as {{ column }}_metric_value,
        {%- endfor %}
    from
        {{ model }}
    group by
        1

),
grouped_metric_values_with_priors as (

    select
        *,
        {%- for column in columns %}
        lag({{ column }}_metric_value, {{ lookback_days }}) over(order by metric_date) as {{ column }}_prior_metric_value,
        {%- endfor %}
  from
      grouped_metric_values d

),
metric_diffs as (

    select
        *,
        {%- for column in columns %}
        {%- if take_logs %}
        coalesce(log(nullif({{ column }}_metric_value, 0)), 0) -
            coalesce(log(nullif({{ column }}_prior_metric_value, 0)), 0) as {{ column }}_metric_diff,
        {%- else -%}
        coalesce({{ column }}_metric_value, 0) -
            coalesce({{ column }}_prior_metric_value, 0) as {{ column }}_metric_diff,
        {%- endif -%}
        {% endfor %}
    from
        grouped_metric_values_with_priors d

),
metric_diffs_moving_calcs as (

    select
        *,
        {%- for column in columns %}
        avg({{ column }}_metric_diff)
            over(order by metric_date rows
                    between {{ trend_days }} preceding and 1 preceding) as {{ column }}_metric_diff_rolling_average,
        stddev({{ column }}_metric_diff)
            over(order by metric_date rows
                    between {{ trend_days }} preceding and 1 preceding) as {{ column }}_metric_diff_rolling_stddev,
        {% endfor %}
    from
        metric_diffs

),
metric_diffs_sigma as (

    select
        *,
        {%- for column in columns %}
        ({{ column }}_metric_diff - {{ column }}_metric_diff_rolling_average) as {{ column }}_metric_diff_delta,
        ({{ column }}_metric_diff - {{ column }}_metric_diff_rolling_average)/
            {{ column }}_metric_diff_rolling_stddev as {{ column }}_metric_diff_sigma,
        {% endfor %}
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
    (
    {%- for column in columns %}
        abs({{ column }}_metric_diff_sigma) > {{ sigma_threshold }}{% if not loop.last %} or {% endif %}
    {% endfor -%}
    )
{%- endmacro -%}
