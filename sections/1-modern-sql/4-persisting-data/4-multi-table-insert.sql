-- see https://docs.snowflake.com/en/sql-reference/sql/insert-multi-table
use test.employees;

table dept;

table emp
order by dept_id;


-- recreate tables w/ LIKE
create or replace table emp_accounting like emp;
create or replace table emp_research like emp;
create or replace table emp_sales like emp;
create or replace table emp_operations like emp;

-- single-table inserts
insert into emp_accounting
SELECT * FROM emp WHERE dept_id = 10;
table emp_accounting;

insert into emp_research
SELECT * FROM emp WHERE dept_id = 20;
table emp_research;

insert into emp_sales
SELECT * FROM emp WHERE dept_id = 30;
table emp_sales;

insert into emp_operations
SELECT * FROM emp WHERE dept_id = 40;
table emp_operations;

-- multi-table inserts (w/ FIRST and ALL)
truncate emp_accounting;
truncate emp_research;
truncate emp_sales;
truncate emp_operations;

INSERT FIRST
   WHEN dept_id = 10 THEN INTO emp_accounting
   WHEN dept_id = 20 THEN INTO emp_research
   WHEN dept_id = 30 THEN INTO emp_sales
   WHEN dept_id = 40 THEN INTO emp_operations
SELECT * FROM emp;

-- OVERWRITE ~= TRUNCATE + CTAS
INSERT OVERWRITE ALL
   WHEN dept_id = 10 THEN INTO emp_accounting
   WHEN dept_id = 20 THEN INTO emp_research
   WHEN dept_id = 30 THEN INTO emp_sales
   ELSE INTO emp_operations
SELECT * FROM emp;

table emp_accounting
union all table emp_research
union all table emp_sales
union all table emp_operations;
