{% macro test_expect_column_values_to_be_unique(model, column_name,
                                                   partition_column=None,
                                                   partition_filter=None) %}

select count(*)
from (

    select
        {{ column_name }}

    from {{ model }}
    where {{ column_name }} is not null
    {% if partition_column and partition_filter %}
        and {{ partition_column }} {{ partition_filter }}
    {% endif %}
    group by {{ column_name }}
    having count(*) > 1

) validation_errors
{% endmacro %}