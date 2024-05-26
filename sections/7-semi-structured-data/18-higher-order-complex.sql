use test.employees;

-- get list of employee names+salaries per department
create or replace view dept_with_emps2 as
    select dept.name as dept,
        array_agg(object_construct(
            'name', emp.name,
            'salary', emp.salary)) as employees
    from dept join emp on dept.dept_id = emp.dept_id
    group by dept.name;
table dept_with_emps2;

-- increase w/ 5% salaries of employees paid > 2000
with cte as (
    select dept, e.value as e
    from dept_with_emps2, lateral flatten(employees) e),
cte2 as (
    -- employees w/ 2000+ salary receive 5% bonus
    select dept, {'name': e:name, 'salary': (1.05 * e:salary)} empl
    from cte
    where e:salary > 2000
    union
    -- join w/ the other employees
    select dept, e as empl
    from cte
    where e:salary <= 2000)
-- restore the aggregation
select dept, array_agg(empl)
from cte2
group by dept;

-- keep only employees w/ salaries > 2000
select dept, filter(employees, e -> e:salary > 2000) emps
from dept_with_emps2;

-- give a 5% bonus to these employees
select dept, transform(
    filter(employees, e -> e:salary > 2000),
    e -> {'name': e:name, 'salary': (1.05 * e:salary)}) emps
from dept_with_emps2;

-- combine with the excluded employees
select dept, array_cat(
        transform(
            filter(employees, e -> e:salary > 2000),
            e -> {'name': e:name, 'salary': (1.05 * e:salary)}),
        filter(employees, e -> e:salary <= 2000)) emps
from dept_with_emps2;
