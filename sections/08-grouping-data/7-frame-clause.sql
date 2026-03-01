-- Window Function Frames
-- https://docs.snowflake.com/en/sql-reference/functions-window-syntax#usage-notes-for-window-frames
use test.employees;

select name, hire_date, salary
from emp
order by hire_date;

-- window frame (--> moving average)
select name, hire_date, salary,
    round(avg(salary) over (order by hire_date
        rows between 2 preceding and current row), 2) as avg
from emp
order by hire_date;
