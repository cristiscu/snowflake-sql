use test.employees;

-- ======================================================
-- uncorrelated subqueries to CTEs

select AVG(e.salary) from emp e;

-- in SELECT
SELECT e2.name, e2.salary,
   (select AVG(e.salary) from emp e) avg_sal
from emp e2;

with cte as (
  select AVG(e.salary) from emp e)
SELECT e2.name, e2.salary, cte.$1
from emp e2, cte;

-- in WHERE
select e2.name, e2.salary
from emp e2
WHERE e2.salary > (select AVG(e.salary) from emp e);

with cte as (
  select AVG(e.salary) from emp e)
select e2.name, e2.salary
from emp e2, cte
WHERE e2.salary > cte.$1;

-- in FROM
select name, salary
FROM (
    select e2.name, e2.salary from emp e2
    where e2.salary > (
      select AVG(e.salary) from emp e));

with cte as (
  select AVG(e.salary) from emp e),
cte2 as (
  select e2.name, e2.salary
  from emp e2, cte
    where e2.salary > cte.$1)
select name, salary
from cte2;

-- ======================================================
-- correlated subqueries to CTEs

select AVG(e.salary)
from emp e
group by dept_id;

-- in SELECT
SELECT e2.name, e2.salary,
   (select AVG(e.salary)
   from emp e
   WHERE e.dept_id = e2.dept_id) avg_sal
from emp e2;

with cte as (
    select AVG(e.salary), e.dept_id
    from emp e
    GROUP BY e.dept_id)
SELECT e2.name, e2.salary, cte.$1
from emp e2, cte
WHERE cte.dept_id = e2.dept_id;

-- in WHERE
select e2.name, e2.salary
from emp e2
WHERE e2.salary > (
   select AVG(e.salary)
   from emp e
   WHERE e.dept_id = e2.dept_id);

with cte as (
    select AVG(e.salary), e.dept_id
    from emp e
    GROUP BY e.dept_id)
SELECT e2.name, e2.salary, cte.$1
from emp e2, cte
WHERE cte.dept_id = e2.dept_id;

-- in FROM
select name, salary
FROM (
    select e2.name, e2.salary from emp e2
    where e2.salary > (
      select AVG(e.salary)
      from emp e
      WHERE e.dept_id = e2.dept_id));

with cte as (
    select AVG(e.salary), e.dept_id
    from emp e
    GROUP BY e.dept_id),
cte2 as (
  SELECT e2.name, e2.salary, cte.$1
  from emp e2, cte
  WHERE cte.dept_id = e2.dept_id)
select name, salary
from cte2; 

-- ==============================================================
-- more complex query to CTEs

select ee.dept_id, sum(ee.salary) as sum_sal,
    (select max(salary)
    from emp
    where dept_id = ee.dept_id) as max_sal
from emp ee
where ee.emp_id in
    (select emp_id
    from emp e join dept d on e.dept_id = d.dept_id
    where d.name <> 'Research')
group by ee.dept_id
order by ee.dept_id;

with q1(emp_id) as (
    select emp_id
    from emp e join dept d on e.dept_id = d.dept_id
    where d.name <> 'Research'),
q2(dept_id, max_sal) as (
    select dept_id, max(salary) max_sal
    from emp
    group by dept_id)
select ee.dept_id,
    sum(ee.salary) as sum_sal,
    max(q2.max_sal) as max_sal
from emp ee
    join q2 on q2.dept_id = ee.dept_id
    join q1 on q1.emp_id = ee.emp_id
group by ee.dept_id
order by ee.dept_id;
