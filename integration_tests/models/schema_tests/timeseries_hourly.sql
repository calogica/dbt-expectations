{% set now = modules.datetime.datetime.now().replace(minute=0, hour=0, second=0, microsecond=0) %}
{% set start_date = (now - modules.datetime.timedelta(10)).isoformat() %}

{{ dbt_date.get_base_dates(
        start_date=start_date,
        end_date=now.isoformat(),
        datepart="hour"
    )
}}
