{% macro test_expect_row_values_to_have_recent_data(model, column_name, datepart, interval) %}
select
    case when count(*) > 0 then 0
    else 1
    end as error_result
from {{model}}
where
    datetime({{column_name}}) >= {{ dbt_utils.dateadd(datepart, interval * -1, dbt_date.now()) }}
    and
    date({{column_name}}) <= {{ dbt_date.today() }}
{% endmacro %}
