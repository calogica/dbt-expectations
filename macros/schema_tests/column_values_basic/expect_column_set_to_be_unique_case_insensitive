{% test expect_column_set_to_be_unique_case_insensitive(model, column_name) %}

 {%- if execute -%}
 with test_data as (

     select
         distinct {{ column_name }} as distinct_values
         FROM
         {{ model }}
         where 1=1

 ),
 validation_errors as
 (
   select
   count(1) as set_count,
   count(distinct lower(distinct_values)) as set_count_case_insensitive
   from test_data
 )
 select * from validation_errors
 where set_count!=set_count_case_insensitive

 {%- endif -%}
 {%- endtest -%}
