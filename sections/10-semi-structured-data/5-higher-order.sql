-- Higher-Order Functions
-- https://docs.snowflake.com/en/user-guide/querying-semistructured#label-higher-order-functions
-- https://medium.com/snowflake/json-data-profiler-as-a-live-streamlit-web-app-54096b00a615

select transform([1, 2, 3], a INT -> a * 2);
select filter([1, 2, 3], a INT -> a >= 2);

select transform([
    {'label':'a', 'value':1},
    {'label':'b', 'value':2},
    {'label':'c', 'value':3}
], a -> {'label':a:label, 'value':a:value * 2});

select transform([
    {'label':'a', 'value':1},
    {'label':'b', 'value':2},
    {'label':'c', 'value':3}
], a -> object_insert(a, 'new', {'value2':a:value * 2}));

select transform(
    filter([
        {'label':'a', 'value':1},
        {'label':'b', 'value':2},
        {'label':'c', 'value':3}
    ], a -> a:value >=2),
    a -> object_insert(a, 'new', {'value2':a:value * 2}));

-- ======================================================
-- REDUCE
-- https://www.snowflake.com/en/engineering-blog/reduce-function-simplify-array-processing/
select reduce([1, 2, 3], 0, (acc INT, a INT) -> acc + a);
select reduce([1, 2, 3], [], (acc, a) -> ARRAY_PREPEND(acc, a)) AS reverse;

select reduce(v.value, 1, (acc, a) -> acc * a)
from table(flatten(input => 
    array_construct([1, 2, 3], [4, 5, 6], [7, 8, 9]))) as v;

-- ======================================================
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
