use schema employees.public;

create or replace table dept (
	dept_id     integer     PRIMARY KEY,
	name        string      NOT NULL UNIQUE,
	location    string      NULL)
comment = 'departments';
    
create or replace table emp (
	emp_id      integer     PRIMARY KEY,
	name        string      NOT NULL UNIQUE,
	job         string		DEFAULT 'SALESMAN',
    education   string,
	mgr_id      integer     NOT NULL FOREIGN KEY REFERENCES deps(emp_id),
	hire_date   date,
	salary      float       DEFAULT 0 NOT NULL,
	commission  float		DEFAULT NULL,
    status      string,
    gender      string,
	dept_id     integer     NOT NULL,
    FOREIGN KEY (dept_id)   REFERENCES deps(dept_id))
comment = 'employees';

create or replace table proj (
	proj_id     integer,
	name        string      NOT NULL,
	start_date  date        NOT NULL,
    end_date    date,
    PRIMARY KEY (proj_id),
    UNIQUE (name))
comment = 'projects';
