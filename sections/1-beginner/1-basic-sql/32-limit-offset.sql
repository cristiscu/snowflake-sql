use test.employees;

select name, salary
from emp
order by salary desc;

-- TOP
select top 3 name, salary
from emp
order by salary desc;

-- LIMIT
select name, salary
from emp
order by salary desc
limit 3;

-- LIMIT OFFSET
select name, salary
from emp
order by salary desc
limit 3 offset 2;

select name, salary
from emp
order by salary desc, name desc
limit 3 offset 2;

-- [OFFSET] FETCH
select name, salary
from emp
order by salary desc, name desc
offset 2 fetch next 3 rows;
