use schema employees.public;

-- this will fail
select name, salary,
    row_number() over (order by salary desc) as rn
from emp
where rn <= 3
order by name;

-- fix w/ subquery/CTE
with cte as (
    select name, salary,
        row_number() over (order by salary desc) as rn
    from emp
    order by name)
select *
from cte
where rn <= 3;

select name, salary,
    row_number() over (order by salary desc) as rn
from emp
qualify rn <= 3
order by name;

-- no RN selection =============================
-- this will fail
select name, salary
from emp
where row_number() over (order by salary desc) <= 3
order by name;

-- fix w/ subquery/CTE
with cte as (
    select name, salary,
        row_number() over (order by salary desc) as rn
    from emp
    order by name)
select name, salary
from cte
where rn <= 3;

select name, salary
from emp
qualify row_number() over (order by salary desc) <= 3
order by name;

-- ========================================================
-- w/ multiple clauses
select emp.name
from emp left join dept on emp.dept_id = dept.dept_id
where job = 'SALESMAN'
group by emp.name
having sum(emp.commission) > 0
qualify row_number() over (order by sum(salary) desc) <= 5
order by emp.name
limit 2;
