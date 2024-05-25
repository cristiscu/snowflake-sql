use test.employees;

-- session variables
set s = 'this is a string';
select $s;

-- scripting block local variables
begin
    let var1 int := 123;
    select top 1 salary into :var1 from emp;
    return var1;
end;

declare
    var1 int default 123;
begin
    select top 1 salary into :var1 from emp;
    return var1;
end;

