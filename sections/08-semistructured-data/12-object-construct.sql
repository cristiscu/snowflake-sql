use schema test.employees;

table emp;

-- without NULLs
create or replace view emp_with_extra as
    select * exclude (salary, commission),
        object_construct(
            'salary', salary,
            'commission', commission) as extra
    from emp;
table emp_with_extra;

select v.*, e.key, e.value
from emp_with_extra v,
    table(flatten(v.extra)) e;

-- with NULLs
create or replace view emp_with_extra_keep_null as
    select * exclude (salary, commission),
        object_construct_keep_null(
            'salary', salary,
            'commission', commission) as extra
    from emp;
table emp_with_extra_keep_null;

select v.*, e.key, e.value
from emp_with_extra_keep_null v,
    table(flatten(v.extra)) e;
