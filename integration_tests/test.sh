dbt seed --target bq &&
dbt run --target bq &&
dbt test --target bq &&
dbt seed --target snowflake &&
dbt run --target snowflake &&
dbt test --target snowflake &&
