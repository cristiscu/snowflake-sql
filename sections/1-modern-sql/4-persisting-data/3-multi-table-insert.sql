-- see https://docs.snowflake.com/en/sql-reference/sql/insert-multi-table
use test.employees;

-- recreate tables w/ LIKE
create or replace table emp_accounting like emp;
alter table emp_accounting drop column dept_id;

create or replace table emp_research like emp_accounting;
create or replace table emp_sales like emp_accounting;
create or replace table emp_operations like emp_accounting;

-- single-table inserts
insert into emp_accounting
    SELECT * EXCLUDE dept_id FROM emp
    WHERE dept_id = 10;
select * from emp_accounting;

insert into emp_research
    SELECT * EXCLUDE dept_id FROM emp
    WHERE dept_id = 20;
select * from emp_research;

insert into emp_sales
    SELECT * EXCLUDE dept_id
    FROM emp
    WHERE dept_id = 30;
select * from emp_sales;

insert into emp_operations
    SELECT * EXCLUDE dept_id FROM emp
    WHERE dept_id = 40;
select * from emp_operations;

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
SELECT * EXCLUDE dept_id
FROM emp;

-- OVERWRITE ~= TRUNCATE + CTAS
INSERT OVERWRITE ALL
   WHEN dept_id = 10 THEN INTO emp_accounting
   WHEN dept_id = 20 THEN INTO emp_research
   WHEN dept_id = 30 THEN INTO emp_sales
   ELSE INTO emp_operations
SELECT * EXCLUDE dept_id
FROM emp;

select * from emp_accounting;
select * from emp_research;
select * from emp_sales;
select * from emp_operations;
