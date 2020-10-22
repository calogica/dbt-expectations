{%- macro test_table_row_count_equal(model, expected_number_of_rows) -%}
select abs({{ expected_number_of_rows }} - count(*)) from {{ model }}
{%- endmacro -%}