{% if execute %}
{%- set source_relation = adapter.get_relation(
      database="bigquery-public-data",
      schema="new_york_citibike",
      identifier="citibike_trips") -%}

{{ log("Source Relation: " ~ source_relation, info=true) }}
{% endif %}

{% if execute %}
{%- set source_relation_2 = adapter.get_relation(
      database=this.database,
      schema=this.schema,
      identifier=this.name) -%}

{{ log("Source Relation: " ~ source_relation_2, info=true) }}
{% endif %}
select
    'ab@gmail.com' as email_address,
    '@[^.]*' as reg_exp

union all

select
    'ab@mail.com' as email_address,
    '@[^.]*' as reg_exp

union all

select
    'abc@gmail.com' as email_address,
    '@[^.]*' as reg_exp

union all

select
    'abc.com@gmail.com' as email_address,
    '@[^.]*' as reg_exp
