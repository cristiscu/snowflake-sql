use test.employees;

-- top employee with biggest salary per department
select dept_id, name, salary
from emp
order by dept_id, salary desc;

select dept_id,
    max(salary) as max_sal
from emp
group by dept_id
order by dept_id;

select dept_id,
    any_value(name) as name,
    max(salary) over (partition by dept_id order by salary desc) as max_sal
from emp e
group by dept_id, salary
qualify salary = max_sal
order by dept_id;

select distinct dept_id,
    first_value(name) over (partition by dept_id order by salary desc) as ename
from emp
order by dept_id;

select dept_id,
    max_by(salary, salary) as max_sal
from emp
group by dept_id;

select dept_id,
    max_by(name, salary) as name
from emp
group by dept_id;

-- ==================================================
- MAX by N columns

-- top 3 employees with biggest salaries per department
select dept_id,
    max_by(name, salary, 3) as names
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
