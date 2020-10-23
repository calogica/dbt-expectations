{%- macro test_expect_table_row_count_to_equal(model, expected_number_of_rows) -%}
select abs({{ expected_number_of_rows }} - count(*)) from {{ model }}
{%- endmacro -%}