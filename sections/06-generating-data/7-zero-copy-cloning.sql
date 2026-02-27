-- Zero-Copy Cloning
-- https://medium.com/snowflake/zero-copy-cloning-in-snowflake-and-other-database-systems-b74fb3a73b3f
-- https://docs.snowflake.com/en/user-guide/object-clone
use test.employees;

select * from dept;

-- CTAS: CREATE TABLE ... AS SELECT ...
create table dept_ctas as select * from dept;
select * from dept_ctas;

-- CREATE TABLE ... LIKE ... 
create table dept_like like dept;
select * from dept_like;
insert overwrite into dept_like select * from dept;
select * from dept_like;

-- zero-copy cloning: CREATE TABLE ... CLONE ...
create table dept_cloned clone dept_ctas;
select * from dept_cloned;

-- cleanup
drop table dept_ctas;
drop table dept_like;
drop table dept_cloned;