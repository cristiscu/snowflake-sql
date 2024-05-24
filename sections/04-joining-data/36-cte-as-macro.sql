-- see https://www.linkedin.com/posts/anton-revyako_snowflake-sql-activity-7193593986303873025-2eVs/?utm_source=share&utm_medium=member_desktop
use test.employees;

select *
from dept
where name = 'Research';

-- the "normal" way --> CTE defined+called as subquery
with cte as (
    select 'Research')
select *
from dept
where name = (select * from cte);

with cte as ('Research')
select *
from dept
where name = cte;

with cte as (dept_id * 3)
select cte
from dept;

with cte as ({'metric': 123})
select cte:metric;
