-- UNION [DISTINCT/ALL] BY NAME
-- https://docs.snowflake.com/en/sql-reference/operators-query#usage-notes-for-the-by-name-clause
use test.employees;
select * from emp; 

-- UNION [DISTINCT] BY NAME with SELECT *
select name, status, salary
from emp
where status <> 'single'
UNION DISTINCT
select name, status, salary
from emp
where salary > 3000
order by name;

select name, status, salary
from emp
where status <> 'single'
UNION DISTINCT BY NAME
select *
from emp
where salary > 3000
order by name;

select *
from emp
where status <> 'single'
UNION BY NAME
select *
from emp
where salary > 3000
order by name;

-- UNION ALL BY NAME with SELECT *
select name, status, salary
from emp
where status <> 'single'
UNION ALL
select name, status, salary
from emp
where salary > 3000
order by name;

select name, status, salary
from emp
where status <> 'single'
UNION ALL BY NAME
select *
from emp
where salary > 3000
order by name;

-- UNION BY NAME with SELECT col1, col2, ...
select name, salary
from emp
where status <> 'single'
UNION BY NAME
select salary, name
from emp
where salary > 3000
order by name;

select name
from emp
UNION BY NAME
select status
from emp
order by name;

select name, status, salary
from emp
where status <> 'single'
UNION BY NAME
select salary, job, name
from emp
where salary > 3000
order by name;

select name, status, salary
from emp
where status <> 'single'
UNION BY NAME
select salary, job, name
from emp
where salary > 3000
UNION BY NAME
select education
from emp
where job = 'CLERK'
order by name;
