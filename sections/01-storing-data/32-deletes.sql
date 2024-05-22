-- see https://docs.snowflake.com/en/sql-reference/sql/delete
use schema employees.public;

select * from dept;

delete from dept
where dept_id = 40;

delete from dept
where dept_id in (select dept_id from emp where job = 'SALESMAN');

delete from dept
where dept.dept_id = emp.dept_id;

-- USING keyword
delete from dept
using emp
where dept.dept_id = emp.dept_id;