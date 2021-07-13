{% test expect_column_values_to_be_within_n_stdevs(model,
                                  column_name,
                                  group_by=None,
                                  sigma_threshold=3
                                ) -%}
    {{ adapter.dispatch('test_expect_column_values_to_be_within_n_stdevs', 'dbt_expectations') (model, column_name, group_by, sigma_threshold) }}
{%- endtest %}

{% macro default__test_expect_column_values_to_be_within_n_stdevs(model,
                                  column_name,
                                  group_by,
                                  sigma_threshold
                                ) %}
with metric_values as (

    {% if group_by -%}
    select
        {{ group_by }} as metric_date,
        sum({{ column_name }}) as {{ column_name }}
    from
        {{ model }}
    group by
        1
    {%- else -%}
    select
        {{ column_name }} as {{ column_name }}
    from
        {{ model }}
    {%- endif %}

),
metric_values_with_statistics as (

    select
        *,
        avg({{ column_name }}) over() as {{ column_name }}_average,
        stddev({{ column_name }}) over() as {{ column_name }}_stddev
    from
        metric_values

),
metric_values_z_scores as (

    select
        *,
        ({{ column_name }} - {{ column_name }}_average)/{{ column_name }}_stddev as {{ column_name }}_sigma
    from
        metric_values_with_statistics

)
select
    *
from
    metric_values_z_scores
where
    abs({{ column_name }}_sigma) > {{ sigma_threshold }}
{%- endmacro %}
