-- (re)create TEST database and schema
drop database if exists test;
create or replace database test;
create schema if not exists test.employees;
use schema test.employees;

use test.employees;

-- ===========================================================
-- Object Identifiers - TODO!

create or replace temp table MyTable(col string, "Id" number) as
    select 'abc', 123;

select * from MYTABLE;
select * from test.employees.MYTABLE;
select * from IDENTIFIER('MYTABLE');
select * from TABLE('MYTABLE');

desc table MyTable;
select "Id" from mytable;
select Id from mytable;

-- ===========================================================
-- Permanent Tables

-- (re)create EMPLOYEES tables
create table dept (
	dept_id     integer,
	name        string,
	location    string);
    
create or replace table emp (
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

create table if not exists proj (
	proj_id     integer,
	name        string,
	start_date  date,
    end_date    date);

-- ===========================================================
-- (re)create and populate EMPLOYEES tables, w/ (uninforced) constraints
create or replace table dept (
	dept_id     integer     PRIMARY KEY,
	name        string      NOT NULL UNIQUE,
	location    string      NULL)
comment = 'departments'
AS SELECT *
FROM VALUES
    (10,    'Accounting',   'New York'  ),
    (20,    'Research',     'Dallas'    ),
    (30,    'Sales',        'Chicago'   ),
    (40,    'Operations',   'Boston'    );
table dept;

create or replace table emp (
	emp_id      integer     PRIMARY KEY,
	name        string      NOT NULL UNIQUE,
	job         string		DEFAULT 'SALESMAN',
    education   string,
	mgr_id      integer     NULL FOREIGN KEY REFERENCES emp(emp_id),
	hire_date   date,
	salary      float       DEFAULT 0 NOT NULL,
	commission  float		DEFAULT NULL,
    status      string,
    gender      string,
	dept_id     integer     NOT NULL,
    FOREIGN KEY (dept_id)   REFERENCES dept(dept_id))
comment = 'employees';

truncate emp;
insert into emp values
    (7839, 'Steven King',       'PRESIDENT',    'college',     null,   '1981-11-17',   5000,   null,   'married',  'M', 10),
    (7698, 'Neena Kochhar',     'MANAGER',      'college',     7839,   '1981-05-01',   2850,   null,   'single',   'F', 30),
    (7654, 'Hermann Baer',      'SALESMAN',     'primary',     7698,   '1981-09-28',   1250,   1400,   'single',   'M', 30),
    (7499, 'Shelley Higgins',   'SALESMAN',     'primary',     7698,   '1981-02-20',   1600,   300.5,  'divorced', 'F', 30),
    (7521, 'Lex De Haan',       'SALESMAN',     'college',     7698,   '1981-02-22',   1250,   500,    'married',  'M', 30),
    (7900, 'Alexander Hunold',  'CLERK',        'secondary',   7698,   '1981-12-03',   950,    null,   'divorced', 'M', 30),
    (7844, 'Bruce Ernst',       'SALESMAN',     null,          7698,   '1981-09-08',   1500,   0,      'married',  'M', 30),
    (7782, 'Valli Pataballa',   'MANAGER',      'secondary',   7839,   '1981-06-09',   2450.5, null,   'divorced', 'M', 10),
    (7934, 'Nancy Greenberg',   'CLERK',        'secondary',   7782,   '1982-01-23',   1300,   null,   'single',   'F', 10),
    (7566, 'Ismael Sciarra',    'MANAGER',      'college',     7839,   '1981-04-02',   2975.8, null,   'married',  'M', 20),
    (7788, 'Jose Manuel Urman', 'ANALYST',      'primary',     7566,   '1982-12-09',   3000,   null,   'divorced', 'M', 20),
    (7876, 'Luis Popp',         'CLERK',        null,          7788,   '1983-01-12',   1100,   null,   null,       'M', 20),
    (7902, 'Den Raphaely',      'ANALYST',      'secondary',   7566,   '1981-12-03',   3000,   null,   'married',  'M', 20),
    (7369, 'Alexander Khoo',    'CLERK',        'primary',     7902,   '1980-12-17',   800,    null,   'married',  'M', 20);
table emp;

create or replace table proj (
	proj_id     integer,
	name        string      NOT NULL,
	start_date  date        NOT NULL,
    end_date    date,
    PRIMARY KEY (proj_id),
    UNIQUE (name))
comment = 'projects';

insert OVERWRITE into proj(proj_id, name, start_date, end_date)
select $1, $2, $3, $4
from values
    (1,    'Cleanup Data',          '1980-12-05',   '1981-01-09'    ),
    (2,    'ETL Pipeline',          '1981-01-09',   '1981-04-02'    ),
    (3,    'Data Preprocessing',    '1981-04-02',   '1981-06-08'    ),
    (4,    'Create Dashboard',      '1981-06-09',   '1981-07-22'    ),
    (5,    'ML Kickoff',            '1981-08-28',   '1981-09-11'    ),
    (6,    'Model Training',        '1981-09-28',   '1982-12-10'    ),
    (7,    'Model Deployment',      '1982-12-11',   null            );
select * from proj;

/*
Alternative w/ CSV File:
------------------------
1,Cleanup Data,1980-12-05,1981-01-09
2,ETL Pipeline,1981-01-09,1981-04-02
3,Data Preprocessing,1981-04-02,1981-06-08
4,Create Dashboard,1981-06-09,1981-07-22
5,ML Kickoff,1981-08-28,1981-09-11
6,Model Training,1981-09-28,1982-12-10
7,Model Deployment,1982-12-11,
*/
