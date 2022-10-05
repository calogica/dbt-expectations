{% test expect_compound_columns_to_be_unique(model,
                                                column_list,
                                                quote_columns=False,
                                                ignore_row_if="all_values_are_missing",
                                                row_condition=None
                                                ) %}
{% if not column_list %}
    {{ exceptions.raise_compiler_error(
        "`column_list` must be specified as a list of columns. Got: '" ~ column_list ~"'.'"
    ) }}
{% endif %}
{%- set ignore_row_if_values = ["all_values_are_missing", "any_value_is_missing"] -%}
{% if ignore_row_if not in ignore_row_if_values %}
    {{ exceptions.raise_compiler_error(
        "`ignore_row_if` must be one of " ~ (ignore_row_if_values | join(", ")) ~ ". Got: '" ~ ignore_row_if ~"'.'"
    ) }}
{% endif %}

{% if not quote_columns %}
    {%- set columns=column_list %}
{% elif quote_columns %}
    {%- set columns=[] %}
        {% for column in column_list -%}
            {% set columns = columns.append( adapter.quote(column) ) %}
        {%- endfor %}
{% else %}
    {{ exceptions.raise_compiler_error(
        "`quote_columns` argument for expect_compound_columns_to_be_unique test must be one of [True, False] Got: '" ~ quote_columns ~"'.'"
    ) }}
{% endif %}

{%- set row_condition_ext -%}

{%- if row_condition  %}
    {{ row_condition }} and
{% endif -%}

{%- set op = "and" if ignore_row_if == "all_values_are_missing" else "or" -%}
    not (
        {% for column in columns -%}
        {{ column }} is null{% if not loop.last %} {{ op }} {% endif %}
        {% endfor %}
    )
{%- endset -%}

with validation_errors as (

    select
        {% for column in columns -%}
        {{ column }}{% if not loop.last %},{% endif %}
        {%- endfor %}
    from {{ model }}
    where
        1=1
    {%- if row_condition_ext %}
        and {{ row_condition_ext }}
    {% endif %}
    group by
        {% for column in columns -%}
        {{ column }}{% if not loop.last %},{% endif %}
        {%- endfor %}
    having count(*) > 1

)
select * from validation_errors
{% endtest %}



