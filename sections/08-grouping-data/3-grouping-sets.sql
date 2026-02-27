-- Grouping Sets
-- https://docs.snowflake.com/en/sql-reference/constructs/group-by-grouping-sets
use test.employees;

-- ==============================================================
-- on single column

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

-- ==============================================================
-- on two columns

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

select 1 as g, status, null as gender, sum(salary)
from emp
group by status
union all
select 2 as g, null, gender, sum(salary)
from emp
group by gender
order by g;

-- ==============================================================
-- visual demo, on 2 columns

-- CUBE
select dept_id,
    to_char(year(hire_date)) as year,
    grouping(dept_id) dept_id_g,
    grouping(year) year_g,
    grouping(dept_id, year) dept_id_year_g,
    sum(salary) sals
from emp
where year > '1980'
group by cube (dept_id, year)
having sum(salary) > 5000
order by dept_id, year;

-- ROLLUP
select dept_id,
    to_char(year(hire_date)) as year,
    grouping(dept_id) dept_id_g,
    grouping(year) year_g,
    grouping(dept_id, year) dept_id_year_g,
    sum(salary) sals
from emp
where year > '1980'
group by rollup (dept_id, year)
having sum(salary) > 5000
order by dept_id, year;

-- GROUPING SETS (by 2 individual columns)
select dept_id,
    to_char(year(hire_date)) as year,
    grouping(dept_id) dept_id_g,
    grouping(year) year_g,
    grouping(dept_id, year) dept_id_year_g,
    sum(salary) sals
from emp
where year > '1980'
group by grouping sets (dept_id, year)
having sum(salary) > 5000
order by dept_id, year;
