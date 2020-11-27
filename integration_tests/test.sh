dbt run --target bq &&
dbt test --target bq &&

dbt run --target snowflake &&
dbt test --target snowflake &&

dbt run --target spark &&
dbt test --target spark
