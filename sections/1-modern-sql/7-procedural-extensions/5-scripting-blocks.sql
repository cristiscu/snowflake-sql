-- Snowflake Scripting Blocks: generic duplicates
use test.employees;

-- hard-coded version
create or replace function dup_dept()
  returns table(dept_id int, name string, location string)
as 'select * from dept
  union all
  select * from dept';

select * from table(dup_dept());

-- w/ CURSOR + RESULTSET_FROM_CURSOR
create or replace procedure dup_any_sp1(table_name varchar)
    returns table()
as
begin
    LET c1 CURSOR FOR
        select * from identifier(?)
        union all
        select * from identifier(?);
    OPEN c1 USING (:table_name, :table_name);
    RETURN TABLE(RESULTSET_FROM_CURSOR(c1));
end;

call dup_any_sp1('dept');
call dup_any_sp1('emp');

-- w/ RESULTSET
create or replace procedure dup_any_sp2(table_name varchar)
    returns table()
as
declare
    r1 RESULTSET DEFAULT (
        select * from identifier(:table_name)
        union all
        select * from identifier(:table_name));
begin
    RETURN TABLE(r1);
end;

call dup_any_sp2('dept');

-- w/ EXECUTE IMMEDIATE
create or replace procedure dup_any_sp3(table_name varchar)
  returns table()
as
begin
    LET stmt := 'select * from ' || table_name
        || ' union all select * from ' || table_name;
    LET r1 RESULTSET := (EXECUTE IMMEDIATE :stmt);
    RETURN TABLE(r1);
end;

call dup_any_sp3('dept');