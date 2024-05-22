using schema employees.public;

-- GROUP BY ALL
select status, sum(salary)
from emp
group by status;

select status, sum(salary)
from emp
group by all;

-- CUBE
select status, sum(salary)
from emp
group by cube (status);

select grouping(status) as g, status, sum(salary)
from emp
group by cube (status)
order by g;

select grouping(status) as g, status, sum(salary)
from emp
group by grouping sets ((status), ())
order by g;

-- ROLLUP
select grouping(status) as g, status, sum(salary)
from emp
group by rollup (status);

select grouping(status) as g, status, sum(salary)
from emp
group by grouping sets ((status), ());

select 0 as g, status, sum(salary)
from emp
group by status
union all
select 1, null, sum(salary)
from emp;
