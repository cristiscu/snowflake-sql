create or replace database test;
use schema test.employees;

create table dept (
	dept_id     integer,
	name        string,
	location    string);
    
create table emp (
	emp_id      integer,
	name        string,
	job         string,
    education   string,
	mgr_id      integer,
	hire_date   date,
	salary      float,
	commission  float,
    status      string,
    gender      string,
	dept_id     integer);

create table proj (
	proj_id     integer,
	name        string,
	start_date  date,
    end_date    date);
