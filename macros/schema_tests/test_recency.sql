{% macro test_recency(model, datepart, interval) %}

{% set column_name = kwargs.get('column_name', kwargs.get('field')) %}

select
    case when count(*) > 0 then 0
    else 1
    end as error_result
from {{model}}
where
    datetime({{column_name}}) >= {{ dbt_utils.dateadd(datepart, interval * -1, dbt_date.now()) }}
    and 
    date({{column_name}}) <= date({{ dbt_date.now() }})
{% endmacro %}
