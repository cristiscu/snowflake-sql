use test.employees;

-- object info
show tables;
show tables like 'emp' in schema employees;
desc table emp;

-- comments
alter table emp set comment = 'emp new comment';
comment on table emp is 'emp another comment';
comment on column emp.emp_id is 'employee ID';

-- create+drop
create temp table ttt(id number);
drop table ttt;
