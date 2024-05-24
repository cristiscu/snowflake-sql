use test.employees;

select * from dept;
update dept set name = 'accounting' where name = 'Research';

-- WHERE case sensitivity
select * from dept where name = 'Accounting';
select * from dept where name = 'accounting';
select * from dept where lower(name) = 'accounting';

select * from dept where name LIKE 'Accounting';
select * from dept where name NOT LIKE 'Accounting';
select * from dept where name LIKE 'accounting';
select * from dept where name LIKE '_ccounting';
select * from dept where name LIKE ALL ('_ccounting', '%counting', '_ccount%');
select * from dept where name LIKE ALL (SELECT '_ccounting', '%counting', '_ccount%');
select * from dept where name LIKE ANY ('Accounting', 'accounting');
select * from dept where name ILIKE 'accounting';
select * from dept where name ILIKE ANY ('Accounting', 'accounting');

-- ORDER BY case sensitivity
select * from dept order by name;
select * from dept order by upper(name);
select * from dept order by lower(name);
select * from dept order by collate(name, 'en');

-- GROUP BY case sensitivity
select name from dept group by name;
select lower(name) lname from dept group by lname;


update dept set name = 'Research' where name = 'accounting';
