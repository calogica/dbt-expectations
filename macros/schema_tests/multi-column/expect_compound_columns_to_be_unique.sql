{% macro test_expect_compound_columns_to_be_unique(model, 
                                                    column_list,
                                                    quote_columns=False,
                                                    ignore_row_if="all_values_are_missing",
                                                    partition_column=None,
                                                    partition_filter=None
                                                    ) %}

{% if not quote_columns %}
    {%- set columns=column_list %}
{% elif quote_columns %}
    {%- set columns=[] %}
        {% for column in column_list -%}
            {% set columns = columns.append( adapter.quote(column) ) %}
        {%- endfor %}
{% else %}
    {{ exceptions.raise_compiler_error(
        "`quote_columns` argument for unique_combination_of_columns test must be one of [True, False] Got: '" ~ quote_columns ~"'.'"
    ) }}
{% endif %}

with compound_column_values as (

    select
        {{ dbt_utils.surrogate_key(columns) }} as column_key,
        {% for column in columns -%}
        {{ column }}{% if not loop.last %},{% endif %}
        {%- endfor %}
    from {{ model }}
    where 1=1
    {% if partition_column and partition_filter %}
        and {{ partition_column }} {{ partition_filter }}
    {% endif %}

),
validation_errors as (
    select
        column_key

    from compound_column_values
    where 1=1
    {% if ignore_row_if == "all_values_are_missing" %}
        and 
        (
            {% for column in columns -%}
            {{ column }} is not null{% if not loop.last %} and {% endif %}
            {%- endfor %}
        )
    {% elif ignore_row_if == "any_value_is_missing" %}
        and
        (
            {% for column in columns -%}
            {{ column }} is not null{% if not loop.last %} or {% endif %}
            {%- endfor %}
        )
    {% endif %}
    group by column_key
    having count(*) > 1

) 
select count(*) from validation_errors
{% endmacro %}