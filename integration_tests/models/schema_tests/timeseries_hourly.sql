{{ dbt_date.date_spine('hour',
        start_date=dbt_date.n_days_ago(10),
        end_date=dbt_date.tomorrow()
    )
}}
