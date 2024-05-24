use schema test.employees;

select dept.dept_id,
    dept.name as department,
    sum(emp.salary) as salaries
from dept join emp on dept.dept_id = emp.dept_id
group by dept.dept_id, department;

select dept.dept_id,
    max(dept.name) as department,
    sum(emp.salary) as salaries
from dept join emp on dept.dept_id = emp.dept_id
group by dept.dept_id;

-- see https://docs.snowflake.com/en/sql-reference/functions/any_value
select dept.dept_id,
    any_value(dept.name) as department,
    sum(emp.salary) as salaries
from dept join emp on dept.dept_id = emp.dept_id
group by dept.dept_id;
