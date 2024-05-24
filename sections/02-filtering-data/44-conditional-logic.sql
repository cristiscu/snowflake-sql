-- create expression for the fixed department name by ID
use schema employees.public;

select * from dept;

-- IFF
select name as employee,
    iff(dept_id = 10, 'Accounting',
    iff(dept_id = 20, 'Research',
    iff(dept_id = 30, 'Sales',
    'Operations'))) as department
from emp;

-- DECODE
select name as employee,
    decode(dept_id, 10, 'Accounting',
    20, 'Research',
    30, 'Sales',
    'Operations') as department
from emp;

-- searched CASE clause
select name as employee,
    case
    when dept_id = 10 then 'Accounting'
    when dept_id = 20 then 'Research'
    when dept_id = 30 then 'Sales'
    else 'Operations' end as department
from emp;

-- simple CASE clause (+ UDF)
select name as employee,
    case dept_id
    when 10 then 'Accounting'
    when 20 then 'Research'
    when 30 then 'Sales'
    else 'Operations' end as department
from emp;

create or replace function get_dept_name(dept_id int)
    returns string 
as $$
    case (dept_id)
    when 10 then 'Accounting'
    when 20 then 'Research'
    when 30 then 'Sales'
    else 'Operations'
    end
$$;

select name as employee,
    get_dept_name(dept_id) as department
from emp;

-- code block and stored proc w/ IF
begin
    let dept_id := 20;
    if (dept_id = 0) then return 'Accounting';
    elseif (dept_id = 20) then return 'Research';
    elseif (dept_id = 30) then return 'Sales';
    else return 'Operations';
    end if;
end;

create or replace procedure ret_dept_name(dept_id int)
    returns string
as
begin
    if (dept_id = 0) then return 'Accounting';
    elseif (dept_id = 20) then return 'Research';
    elseif (dept_id = 30) then return 'Sales';
    else return 'Operations';
    end if;
end;

call ret_dept_name(20);
