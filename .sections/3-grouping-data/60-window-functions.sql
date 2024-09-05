use schema test.employees;

-- window frame (--> moving average)
select name, hire_date, salary,
    round(avg(salary) over (order by hire_date
        rows between 2 preceding and current row), 2) as avg
from emp
order by hire_date;

-- rank functions
select dept_id, name,
    row_number() over (order by dept_id) row_number,
    rank() over (order by dept_id) rank,
    dense_rank() over (order by dept_id) dense_rank,
    round(percent_rank() over (order by dept_id) * 100) || '%' percent_rank,
    ntile(3) over (order by dept_id) bucket
from emp
order by dept_id;

-- offset functions
select name, hire_date,
    lead(salary, 1) over (order by hire_date) lead,
    salary,
    lag(salary, 1) over (order by hire_date) lag,
    case when lag > salary then 'down' else 'up' end var,
    first_value(salary) over (order by hire_date) first,
    last_value(salary) over (order by hire_date) last,
    nth_value(salary, 1) over (order by hire_date) nth
from emp
order by hire_date;
