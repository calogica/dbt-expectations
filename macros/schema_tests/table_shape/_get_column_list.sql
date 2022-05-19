{%- macro _get_column_list(model) -%}
    {%- if (model is mapping and obj.get('metadata', {}).get('type', '').endswith('Relation')) -%}
        {%- set relation_columns = adapter.get_columns_in_relation(model) -%}
    {%- else -%}
        {%- set relation_columns = adapter.get_columns_in_query(model) -%}
    {%- endif -%}

    {%- do return(relation_columns) -%}
{%- endmacro -%}
