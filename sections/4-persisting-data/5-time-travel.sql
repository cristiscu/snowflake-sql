use test.employees;

select * from dept;

-- replace string value below w/ your own Query ID of the previous query
select * from dept
before (statement => '01b47a41-0002-6f96-0061-80070001c182');

select * from dept
at (offset => -1000);

select * from dept
at (timestamp => dateadd(hour, -2, current_timestamp()));

select * from dept
before (timestamp => current_timestamp() - interval '2 hours');

select * from dept
before (timestamp => current_timestamp() - interval '10 days');

show tables like 'dept';

-- also for account/database/schema
show parameters like 'data_retention_time_in_days' for table dept;

alter table dept set data_retention_time_in_days = 3;

-- drop and recover table
drop table dept;

select * from dept;

undrop table dept;

select * from dept;

-- recover table, with content
create or replace table dept2 as
select * from dept
before (timestamp => current_timestamp() - interval '2 hours');

select * from dept2;

drop table dept;
alter table dept2 rename to dept;
select * from dept;

-- check changes, including for dropped & recovered tables
show tables HISTORY like 'dept%';
