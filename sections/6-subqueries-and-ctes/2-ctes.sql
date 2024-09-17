use test.employees;

-- =======================================================
-- CTEs as macros
-- see https://www.linkedin.com/posts/anton-revyako_snowflake-sql-activity-7193593986303873025-2eVs/?utm_source=share&utm_medium=member_desktop

select *
from dept
where name = 'Research';

-- the "normal" way --> CTE defined+called as subquery
with cte as (
    select 'Research')
select *
from dept
where name = (select * from cte);

with cte as ('Research')
select *
from dept
where name = cte;

with cte as (dept_id * 3)
select cte
from dept;

with cte as ({'metric': 123})
select cte:metric;

-- =======================================================
-- CTEs from complex query
-- see https://medium.com/snowflake/how-qualify-works-with-in-depth-explanation-and-examples-bbde9fc742db

select distinct fruits.name, sum(sales.quantity) as sold
from (values ('apples', 100), ('oranges', 50),
    ('nuts', 500), ('grapes', 200), ('plums', 0))
    as fruits(name, stock)
join (values ('apples', 10), ('apples', 0),
    ('oranges', 10), ('nuts', 12), ('nuts', 0),
    ('grapes', 25), ('oranges', 20), ('nuts', 15))
    as sales(name, quantity)
on fruits.name = sales.name
where fruits.stock > 0 and sales.quantity > 0
group by fruits.name, fruits.stock
having sold < fruits.stock
qualify row_number() over (order by fruits.name) >= 2
order by sold desc
limit 2;

-- (1) the FROM clause (with tables/subqueries)
with fruits(name, stock) as (
  select *
  from (values ('apples', 100), ('oranges', 50),
    ('nuts', 500), ('grapes', 200), ('plums', 0))),
sales(name, quantity) as (
  select * 
  from (values ('apples', 10), ('apples', 0),
    ('oranges', 10), ('nuts', 12), ('nuts', 0),
    ('grapes', 25), ('oranges', 20), ('nuts', 15))),

-- (2) the JOIN-ON clauses (on FROM)
fruits_and_sales as (
  select fruits.name, fruits.stock, sales.quantity
  from fruits
  join sales on fruits.name = sales.name),

-- (3) the WHERE clause (on whole FROM data)
where_filter as (
  select * from fruits_and_sales
  where stock > 0 and quantity > 0),

-- (4) the GROUP BY clause (on already filtered data)
group_by as (
  select name, stock, sum(quantity) as sold 
  from where_filter
  group by name, stock),

-- (5) the HAVING clause (always on groups! with WHERE, because we already grouped data!)
having_filter as (
  select * from group_by
  where sold < stock),

-- (6) the OVER clauses (with window functions)
win_funcs as (
  select *, row_number() over (order by name) as rn
  from having_filter),

-- (7) the QUALIFY clause (with WHERE, because we already calculated the window functions!)
qualify_filter as (
  select * from win_funcs
  where rn >= 2),

-- (8) the DISTINCT clause (with GROUP BY, on all projection fields)
distinct_filter as (
  select name, stock, sold, rn
  from qualify_filter
  group by name, stock, sold, rn),

-- (9) the ORDER BY clause
order_by as (
  select * from distinct_filter
  order by sold desc)

-- (10) the LIMIT/TOP clauses
select name, sold
from order_by
limit 2;

-- =======================================================
-- CTEs from subqueries

-- subqueries
select ee.dept_id,
  sum(ee.salary) as sum_sal,
  (select max(salary)
   from emp
   where dept_id = ee.dept_id) as max_sal
from emp ee
where ee.emp_id in
  (select emp_id
   from emp e
   join dept d on e.dept_id = d.dept_id
   where d.name <> 'RESEARCH')
group by ee.dept_id
order by ee.dept_id;

-- equivalent CTEs
with q1 as 
  (select emp_id
   from emp e
   join dept d on e.dept_id = d.dept_id
   where d.name <> 'RESEARCH'),

q2 as 
  (select dept_id, max(salary) max_sal
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
