use schema test.employees;

-- top 3 employees with biggest salaries per department
select dept_id, max_by(name, salary, 3) as names
from emp
group by dept_id;

with cte as (
    select dept_id, max_by(name, salary, 3) as names
    from emp
    group by dept_id)
select dept_id, n.value as name
from cte, table(flatten(names)) n;

select dept_id,
    min_by(name, salary, 3) as min_names,
    max_by(name, salary, 3) as max_names
from emp
group by dept_id;
