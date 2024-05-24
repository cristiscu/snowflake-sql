use schema test.employees;

-- count of employees with and without commision, per job title
select job,
    (select count(*) from emp
     where job = e.job and commission is not null) as with_commission,
    (select count(*) from emp
     where job = e.job and commission is null) as without_commission
from emp e
group by job
order by with_commission desc;

-- count with SUM
select job,
    sum(case when commission is not null
        then 1 else 0 end) as with_commission,
    sum(case when commission is null
        then 1 else 0 end) as without_commission
from emp
group by job
order by with_commission desc;

-- https://joshdevlin.com/blog/conditional-count-snowflake-count_if/
select job,
    count_if(commission is not null) as with_commission,
    count_if(commission is null) as without_commission
from emp
group by job
order by with_commission desc;