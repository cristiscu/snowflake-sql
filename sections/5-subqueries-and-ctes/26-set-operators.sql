use test.employees;

select name, status, salary
from emp
order by name;

-- UNION [ALL]
select name, status, salary
from emp
where status <> 'single'
UNION
select name, status, salary
from emp
where salary > 3000
order by name;

select name, status, salary
from emp
where status <> 'single' OR salary > 3000
order by name;

-- INTERSECT [ALL]
select name, status, salary
from emp
where status <> 'single'
INTERSECT
select name, status, salary
from emp
where salary > 3000
order by name;

select name, status, salary
from emp
where status <> 'single' AND salary > 3000
order by name;

select distinct name
from emp
where name IN (select name from emp where status <> 'single')
    AND name IN (select name from emp where salary > 3000)
order by name;

select distinct e.name
from emp e
where EXISTS (select null from emp where name = e.name and status <> 'single')
    AND EXISTS (select null from emp where name = e.name and salary > 3000)
order by e.name;

select distinct e.name
from emp e
    inner join emp e1 on e1.name = e.name and e1.status <> 'single'
    inner join emp e2 on e2.name = e.name and e2.salary > 3000
order by e.name;

-- EXCEPT/MINUS [ALL]
select name, status, salary
from emp
where status <> 'single'
EXCEPT
select name, status, salary
from emp
where salary > 3000
order by name;

select name, status, salary
from emp
where status <> 'single' AND NOT (salary > 3000)
order by name;

select distinct name
from emp
where name IN (select name from emp where status <> 'single')
    AND name NOT IN (select name from emp where salary > 3000)
order by name;

select distinct e.name
from emp e
where EXISTS (select null from emp where name = e.name and status <> 'single')
    AND NOT EXISTS (select null from emp where name = e.name and salary > 3000)
order by e.name;

