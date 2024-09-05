use test.employees;

create or replace temp table MyTable(col string, "Id" number) as
    select 'abc', 123;

select * from MYTABLE;
select * from test.employees.MYTABLE;
select * from IDENTIFIER('MYTABLE');
select * from TABLE('MYTABLE');

desc table MyTable;
select "Id" from mytable;
select Id from mytable;
