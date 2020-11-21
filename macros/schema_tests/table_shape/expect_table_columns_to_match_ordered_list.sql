{%- macro test_expect_table_columns_to_match_ordered_list(model, column_list) -%}
{%- set ordered_column_names = column_list | join(", ") -%}
{%- set column_names_in_relation = adapter.get_columns_in_relation(model) | map(attribute="name") | join(", ") -%}
select case when '{{ ordered_column_names }}' = '{{ column_names_in_relation }}' then 0 else 1 end
{%- endmacro -%}