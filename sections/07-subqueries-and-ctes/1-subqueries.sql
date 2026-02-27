-- Subqueries
-- https://docs.snowflake.com/en/user-guide/querying-subqueries
use test.employees;

-- ======================================================
-- uncorrelated subqueries
-- in SELECT/WHERE/FROM, but also in HAVING/GROUP BY/ORDER BY

select AVG(e.salary) from emp e;

-- in SELECT
SELECT e2.name, e2.salary,
   (select AVG(e.salary) from emp e) avg_sal
from emp e2;

-- in WHERE
select e2.name, e2.salary
from emp e2
WHERE e2.salary > (select AVG(e.salary) from emp e);

-- in FROM
select name, salary
FROM (
    select e2.name, e2.salary from emp e2
    where e2.salary > (
      select AVG(e.salary) from emp e));

-- ======================================================
-- correlated subqueries

select AVG(e.salary)
from emp e
group by dept_id;

-- in SELECT
SELECT e2.name, e2.salary,
   (select AVG(e.salary)
   from emp e
   WHERE e.dept_id = e2.dept_id) avg_sal
from emp e2;

-- in WHERE
select e2.name, e2.salary
from emp e2
WHERE e2.salary > (
   select AVG(e.salary)
   from emp e
   WHERE e.dept_id = e2.dept_id);

-- in FROM
select name, salary
FROM (
    select e2.name, e2.salary from emp e2
    where e2.salary > (
      select AVG(e.salary)
      from emp e
      WHERE e.dept_id = e2.dept_id));
