select 'ab@gmail.com' as email_address, '@[^.]*' as reg_exp

union all

select 'ab@mail.com', '@[^.]*'

union all

select 'abc@gmail.com', '@[^.]*'

union all

select 'abc.com@gmail.com', '@[^.]*'
