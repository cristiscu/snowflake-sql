-- see https://docs.snowflake.com/en/sql-reference/sql/update#usage-notes
use test.employees;

select * from dept;

select dept_id, name
from emp
where job = 'SALESMAN';

update dept
    set dept_id = -30
    where dept_id in (
        select dept_id
        from emp
        where job = 'SALESMAN');

show parameters
    like 'ERROR_ON_NONDETERMINISTIC_UPDATE'
    for session;

-- set ERROR_ON_NONDETERMINISTIC_UPDATE = TRUE;
ALTER SESSION SET ERROR_ON_NONDETERMINISTIC_UPDATE = TRUE;

