use test.employees;

select * from dept;
update dept set name = 'accounting' where name = 'Research';

select * from dept where name REGEXP '.*ccount.*';
select * from dept where name NOT REGEXP '.*ccount.*';
select * from dept where RLIKE(name, '.*ccount.*', 'i');
select name, RLIKE(name, '.*ccount.*', 'i') as match from dept;
select name, REGEXP_LIKE(name, '.*ccount.*', 'i') as match from dept;
select name, REGEXP_COUNT(name, '.*ccount.*') as match from dept;


update dept set name = 'Research' where name = 'accounting';
