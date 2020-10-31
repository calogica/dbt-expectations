{%- macro test_expect_table_row_count_to_be_between(model, 
                                                      minimum, 
                                                      maximum, 
                                                      partition_column=None,
                                                      partition_filter=None
                                                    ) -%}
with row_count as (
    select count(*) as cnt 
    from {{ model }}
    {% if partition_column and partition_filter %}
    where {{ partition_column }} {{ partition_filter }}
    {% endif %}
)
select count(*)
from 
    row_count
where cnt < {{ minimum }} or
      cnt > {{ maximum }}
{%- endmacro -%}