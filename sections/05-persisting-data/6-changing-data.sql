-- Changing Data (DML, CRUD operations)
use test.employees;

-- CTAS vs CLONE vs LIKE
create or replace table dept5 as select * from dept;
table dept5;

create or replace table emp5 clone emp;
table emp5;

-- UPDATE
-- https://docs.snowflake.com/en/sql-reference/sql/update#usage-notes

-- step 1 --> multi-joined row w/ non-deterministic update ok
select name, dept_id from emp5 where job = 'SALESMAN';

update dept5 set dept_id = -30
from emp5
where dept5.dept_id = emp5.dept_id and emp5.job = 'SALESMAN';
table dept5;

show parameters like 'ERROR_ON_NONDETERMINISTIC_UPDATE'
for session;

-- step 2 --> error on non-deterministic update
ALTER SESSION SET ERROR_ON_NONDETERMINISTIC_UPDATE = TRUE;

create or replace table dept5 as select * from dept;
table dept5;

update dept5 set dept_id = -30
from emp5
where dept5.dept_id = emp5.dept_id and emp5.job = 'SALESMAN';

-- step 3 --> avoid multi-join, so non-deterministic update ok
update dept5 set dept_id = -30
where dept_id in (select dept_id from emp5 where job = 'SALESMAN');
table dept5;

-- DELETE
-- https://docs.snowflake.com/en/sql-reference/sql/delete#usage-notes

create or replace table dept5 as select * from dept;
table dept5;

-- emp5 not in FROM --> this will fail
delete from dept5
where dept5.dept_id = emp5.dept_id and emp5.job = 'SALESMAN';

-- USING keyword --> for other tables joined
delete from dept5
using emp5
where dept5.dept_id = emp5.dept_id and emp5.job = 'SALESMAN';
table dept5;

-- alternative w/o USING
create or replace table dept5 as select * from dept;
table dept5;

delete from dept5
where dept_id in (select dept_id from emp5 where job = 'SALESMAN');
table dept5;

-- UPSERT (i.e. UPDATE or INSERT)
-- https://docs.snowflake.com/en/sql-reference/sql/merge#examples

create or replace table dept5 as select * from dept;
table dept5;

create or replace table dept6 (
	dept_id     integer,
	name        string,
	location    string)
AS SELECT * FROM VALUES
    (20,    'Research2',   'Dallas2'  ),
    (50,    'New Dept',    'New City' );
table dept6;

merge into dept5 using dept6 on dept5.dept_id = dept6.dept_id
when not matched then insert all by name
when matched then update all by name;
table dept5;
