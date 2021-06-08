{% macro get_columns_in_relation_sql(relation) %}

    {{ adapter.dispatch('get_columns_in_relation_sql', 'dbt_expectations')(relation) }}

{% endmacro %}

{% macro redshift__get_columns_in_relation_sql(relation) %}
{#-
See https://github.com/fishtown-analytics/dbt/blob/23484b18b71010f701b5312f920f04529ceaa6b2/plugins/redshift/dbt/include/redshift/macros/adapters.sql#L71
Edited to include ordinal_position
-#}
with bound_views as (

    select
        ordinal_position,
        table_schema,
        column_name,
        data_type,
        character_max_value_length,
        numeric_precision,
        numeric_scale

    from
        information_schema."columns"
    where
        table_name = '{{ relation.identifier }}'

),
unbound_views as (

    select
        ordinal_position,
        view_schema,
        col_name,
        case
            when col_type ilike 'character varying%' then
            'character varying'
            when col_type ilike 'numeric%' then 'numeric'
            else col_type
        end as col_type,
        case
            when col_type like 'character%'
            then nullif(REGEXP_SUBSTR(col_type, '[0-9]+'), '')::int
            else null
        end as character_max_value_length,
        case
            when col_type like 'numeric%'
            then nullif(
            SPLIT_PART(REGEXP_SUBSTR(col_type, '[0-9,]+'), ',', 1),
            '')::int
            else null
        end as numeric_precision,
        case
            when col_type like 'numeric%'
            then nullif(
            SPLIT_PART(REGEXP_SUBSTR(col_type, '[0-9,]+'), ',', 2),
            '')::int
            else null
        end as numeric_scale

    from
        pg_get_late_binding_view_cols()
            cols(view_schema name, view_name name, col_name name,
                col_type varchar, ordinal_position int)
    where
        view_name = '{{ relation.identifier }}'

),
unioned as (

    select * from bound_views
    union all
    select * from unbound_views

)
select
    *
from unioned
{% if relation.schema %}
where
    table_schema = '{{ relation.schema }}'
{% endif %}
order by
    ordinal_position

{% endmacro %}

{% macro snowflake__get_columns_in_relation_sql(relation) %}
{#-
From: https://github.com/fishtown-analytics/dbt/blob/dev/louisa-may-alcott/plugins/snowflake/dbt/include/snowflake/macros/adapters.sql#L48
Edited to include ordinal_position
-#}
select
    ordinal_position,
    column_name,
    data_type,
    character_max_value_length,
    numeric_precision,
    numeric_scale

from
    {{ relation.information_schema('columns') }}

where
    table_name ilike '{{ relation.identifier }}'
    {% if relation.schema %}
    and table_schema ilike '{{ relation.schema }}'
    {% endif %}
    {% if relation.database %}
    and table_catalog ilike '{{ relation.database }}'
    {% endif %}
order by
    ordinal_position
{% endmacro %}

{% macro postgres__get_columns_in_relation_sql(relation) %}
{#-
From: https://github.com/fishtown-analytics/dbt/blob/23484b18b71010f701b5312f920f04529ceaa6b2/plugins/postgres/dbt/include/postgres/macros/adapters.sql#L32
Edited to include ordinal_position
-#}
select
    ordinal_position,
    column_name,
    data_type,
    character_max_value_length,
    numeric_precision,
    numeric_scale

from {{ relation.information_schema('columns') }}
where
    table_name = '{{ relation.identifier }}'
    {% if relation.schema %}
    and table_schema = '{{ relation.schema }}'
    {% endif %}
order by
    ordinal_position
{% endmacro %}


{% macro bigquery__get_columns_in_relation_sql(relation) %}

select
    ordinal_position,
    column_name,
    data_type

from `{{ relation.database }}`.`{{ relation.schema }}`.INFORMATION_SCHEMA.COLUMNS
where
    table_name = '{{ relation.identifier }}'
{% endmacro %}
