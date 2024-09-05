use test.employees;

-- GROUP BY ALL
select status, gender, sum(salary)
from emp
group by status, gender;

select status, gender, sum(salary)
from emp
group by all;

-- CUBE
select status, gender, sum(salary)
from emp
group by cube (status, gender);

select grouping(status, gender) as g,
    status, gender, sum(salary)
from emp
group by cube (status, gender)
order by g;

select grouping(status, gender) as g,
    status, gender, sum(salary)
from emp
group by grouping sets ((status, gender), (status), (gender), ())
order by g;

-- ROLLUP
select grouping(status, gender) as g,
    status, gender, sum(salary)
from emp
group by rollup (status, gender)
order by g;

select grouping(status, gender) as g,
    status, gender, sum(salary)
from emp
group by grouping sets ((status, gender), (status), ())
order by g;

select grouping(status, gender) as g,
    status, gender, sum(salary)
from emp
group by grouping sets (status, gender)
order by g;

select 1 as g, status, null, sum(salary)
from emp
group by status
union all
select 2 as g, null, gender, sum(salary)
from emp
group by gender
order by g;

select grouping(status) as g1,
    grouping(gender) as g2,
    grouping(status, gender) as g
from emp
group by grouping sets ((status, gender), (status), (gender), ())
order by g nulls last;

select 0 as g, status, gender, sum(salary)
from emp
group by status, gender
union all
select 1, status, null, sum(salary)
from emp
group by status
union all
select 3, null, null, sum(salary)
from emp;
