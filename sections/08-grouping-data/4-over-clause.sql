select name, hire_date,
    lead(salary, 1) over (order by hire_date) lead,
    salary,
    lag(salary, 1) over (order by hire_date) lag,
    case when lag > salary then 'down' else 'up' end var,
    first_value(salary) over (order by hire_date) first,
    last_value(salary) over (order by hire_date) last,
    nth_value(salary, 1) over (order by hire_date) nth
from test.employees.emp
order by hire_date;

select name, hire_date,
    lead(salary, 1) over win lead,
    salary,
    lag(salary, 1) over win lag,
    case when lag > salary then 'down' else 'up' end var,
    first_value(salary) over win first,
    last_value(salary) over win last,
    nth_value(salary, 1) over win nth
from test.employees.emp
window win as (order by hire_date)
order by hire_date;
