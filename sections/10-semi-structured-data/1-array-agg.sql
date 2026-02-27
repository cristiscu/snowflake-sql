-- Array Aggregation
-- https://docs.snowflake.com/en/sql-reference/functions/array_agg
use test.employees;

-- aggregate (create array of employee names, denormalized)
create or replace view dept_with_emps as
    select dept.name as dept,
        ARRAY_AGG(distinct emp.name) as employees
    from dept left join emp on dept.dept_id = emp.dept_id
    group by dept.name;
table dept_with_emps;

-- disaggregate (show tabular again, normalized)
select dept, e.value, e.index
from dept_with_emps v,
    table(FLATTEN(v.employees, outer => TRUE)) e
order by dept;

