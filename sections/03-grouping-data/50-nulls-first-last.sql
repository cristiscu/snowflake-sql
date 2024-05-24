use schema test.employees;

select commission, name
from emp
order by commission, name;

select commission, name
from emp
order by commission nulls first, name;

select commission, name
from emp
order by commission desc, name;

select commission, name
from emp
order by commission desc nulls last, name;

-- emulated NULLS LAST
select commission, name
from emp
where commission is not null
-- order by commission desc, name
union all
select commission, name
from emp
where commission is null
order by commission desc, name;

-- see https://docs.snowflake.com/en/sql-reference/data-types-numeric#special-values
select ifnull(commission, '-inf') as comm, name
from emp
order by comm desc, name;