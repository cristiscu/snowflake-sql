use schema employees.public;

-- 4-level hierarchy (w/ joins)
-- https://docs.snowflake.com/en/user-guide/queries-hierarchical
with cte as (
  select e.employee as name,
    coalesce(m3.employee || '.', '')
      || coalesce(m2.employee || '.', '')
      || coalesce(m1.employee || '.', '')
      || e.employee as path
  from employee_manager e
    left join employee_manager m1 on e.manager = m1.employee
    left join employee_manager m2 on m1.manager = m2.employee
    left join employee_manager m3 on m2.manager = m3.employee)
select regexp_count(path, '\\.') as level,
  repeat('  ', level) || name as name,
  path
from cte
order by path;

-- without any CTE/subquery
select coalesce(m3.employee || '.', '')
    || coalesce(m2.employee || '.', '')
    || coalesce(m1.employee || '.', '')
    || e.employee as path,
  regexp_count(path, '\\.') as level,
  repeat('  ', level) || e.employee as name
from employee_manager e
  left join employee_manager m1 on e.manager = m1.employee
  left join employee_manager m2 on m1.manager = m2.employee
  left join employee_manager m3 on m2.manager = m3.employee
order by path;

-- CONNECT BY (only for self-joins)
-- https://docs.snowflake.com/en/sql-reference/constructs/connect-by
select repeat('  ', level - 1) || employee as name, 
  ltrim(sys_connect_by_path(employee, '.'), '.') as path
from employee_manager
start with manager is null
connect by prior employee = manager
order by path;
