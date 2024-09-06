-- see https://medium.com/snowflake/how-qualify-works-with-in-depth-explanation-and-examples-bbde9fc742db

select $1
from (values ('apples'), ('oranges'), ('nuts'))
order by $1;

select top 2 $1
from (values ('apples'), ('oranges'), ('nuts'))
order by $1;

select $1
from (values ('apples'), ('oranges'), ('nuts'))
order by $1
limit 2;

select $1
from (values ('apples'), ('oranges'), ('nuts'))
order by $1
limit 2;

-- ============================================================
-- these both fail
select name
from (values ('apples'), ('oranges'), ('nuts')) as fruits(name)
where row_number() over (order by name) >= 2
order by name;

select name, row_number() over (order by name) as rn
from (values ('apples'), ('oranges'), ('nuts')) as fruits(name)
where rn >= 2
order by name;

-- typical fix (with subquery)
with cte as (
    select name, row_number() over (order by name) as rn
    from (values ('apples'), ('oranges'), ('nuts')) as fruits(name)
    order by name)
select *
from cte
where rn >= 2;

-- alternatives with QUALIFY
select name, row_number() over (order by name) as rn
from (values ('apples'), ('oranges'), ('nuts')) as fruits(name)
qualify rn >= 2
order by name;

select name
from (values ('apples'), ('oranges'), ('nuts')) as fruits(name)
qualify row_number() over (order by name) >= 2
order by name;

-- ==============================================================
-- a more complex query
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

-- equivalent with subqueries
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

-- (5) the HAVING clause (always on groups!)
-- (with WHERE, because we already grouped data!)
having_filter as (
    select * from group_by
    where sold < stock),

-- (6) the OVER clauses (with window functions)
win_funcs as (
    select *, row_number() over (order by name) as rn
    from having_filter),

-- (7) the QUALIFY clause (with WHERE,
-- because we already calculated the window functions!)
qualify_filter as (
    select * from win_funcs
    where rn >= 2),

-- (8) the DISTINCT clause
-- (with GROUP BY, on all projection fields)
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
