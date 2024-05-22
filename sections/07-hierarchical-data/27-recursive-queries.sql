use schema employees.public;

-- recursive CTE
-- https://docs.snowflake.com/en/sql-reference/constructs/with#recursive-clause
with recursive cte (level, name, path, employee) as (
  select 1, employee, employee, employee
    from employee_manager
    where manager is null
  union all
  select m.level + 1,
    repeat('  ', level) || e.employee,
    path || '.' || e.employee,
    e.employee
    from employee_manager e join cte m on e.manager = m.employee)
select name, path
from cte
order by path;

-- recursive view
-- https://docs.snowflake.com/en/sql-reference/sql/create-view#examples
create or replace recursive view employee_hierarchy (
    level, name, path, employee) as (
    select 1, employee, employee, employee
        from employee_manager
        where manager is null
    union all
    select m.level + 1,
        repeat('  ', level) || e.employee,
        path || '.' || e.employee,
        e.employee
        from employee_manager e join employee_hierarchy m on e.manager = m.employee);

select name, path
from employee_hierarchy
order by path;
