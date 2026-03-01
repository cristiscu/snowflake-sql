-- Duplicate vs distinct values
use test.employees;

-- must return only those rows where job value
-- appears only once/multiple times in the results
select name, job
from emp
order by job;

select job, count(*)
from emp
group by job;

-- ===================================================
-- with left outer joins

-- duplicate rows
select distinct e1.name, e1.job
from emp e1
    left join emp e2
    on e1.job = e2.job and e1.name <> e2.name
where e2.name is not null;

-- unicate rows
select distinct e1.name, e1.job
from emp e1
    left join emp e2
    on e1.job = e2.job and e1.name <> e2.name
where e2.name is null;

-- ===================================================
-- with nested correlated subquery (unsupported!)

-- duplicate rows
select e1.name, e1.job
from emp e1
where (select count(*)
    from emp e2
    where e2.job = e1.job
    group by e2.job) > 1;

-- ===================================================
-- with window function

-- duplicate rows
select name, job, count(*) over (partition by job) as count
from emp
where count > 1;

select name, job, count(*) over (partition by job) as count
from emp
qualify count > 1;

select name, job
from emp
qualify count(*) over (partition by job) > 1;

-- unicate rows
select name, job
from emp
qualify count(*) over (partition by job) = 1;
