-- MAX/MIN_BY: get first employee (with duplicates!)/first N employees with max salary per department
-- see https://docs.snowflake.com/en/sql-reference/functions/max_by
use test.employees;

-- first employee (in alphabetical order!) with biggest salary per department
select dept_id, max(salary) as max_sal
from emp
group by 1
order by 1;

select dept_id, name, salary,
    (select max(salary)
    from emp
    where dept_id = e.dept_id) as max_salary
from emp e
order by 1, 3 desc, 2;

-- this gives duplicates
with cte as (
    select dept_id as did, max(salary) as max_sal
    from emp
    group by 1)
select dept_id, name, salary
from emp join cte on dept_id = did
where salary = max_sal
order by 1, 2;

-- fixed duplicates
with cte as (
    select dept_id as did, max(salary) as max_sal
    from emp
    group by 1),
cte2 as (
    select dept_id, name, salary
    from emp join cte on dept_id = did
    where salary = max_sal
    order by 1, 2)
select dept_id, any_value(name) as name, salary
from cte2
group by 1, 3;

-- equivalent w/ MAX window function (and fixed duplicates)
select dept_id,
    min(name) as name,
    max(salary) over (partition by dept_id order by salary desc) as max_sal
from emp e
group by 1, salary
qualify salary = max_sal
order by 1, 2;

-- equivalent with FIRST_VALUE window function (and fixed duplicates)
select distinct dept_id,
    first_value(name) over (partition by dept_id order by salary desc, name) as ename
from emp
order by 1;

-- ==================================================
-- MAX_BY 1

-- ~MAX(salary)
select dept_id, MAX_BY(salary, salary) as max_sal
from emp
group by 1;

-- not OK (not the right duplicate on top)
select dept_id, MAX_BY(name, salary) as name
from emp
group by 1
order by 1;

-- fixed for duplicates
select dept_id, MAX_BY(name, salary) as name
from (select dept_id, name, salary from emp order by 2)
group by 1
order by 1;
