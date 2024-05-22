use schema employees.public;

-- EXCLUDE clause
select * from emp;
select * exclude dept_id
from emp;

select * exclude (salary, commission)
from emp;

select * rename emp_id as empno
from emp;

-- ILIKE clause
select * ilike '%\_id'
from emp;
select * ilike '%\_id' replace('EMP-' || emp_id as emp_id)
from emp;

-- TABLE statement
table dept;
table emp;
table proj;

-- no FROM dual
select 1;

select 1 group by 1 having 1=1;

-- no AS x at the end
SELECT C FROM (SELECT COUNT(*) AS C FROM dept);

select *
from dept left join emp
    on dept.dept_id = emp.dept_id;
