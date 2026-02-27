-- Pipe Operator (->>)
-- https://docs.snowflake.com/en/sql-reference/operators-flow
use test.employees;

create or replace table fruits(name, stock)
as select * from values
    ('apples', 100), ('oranges', 50),
    ('nuts', 500), ('grapes', 200), ('plums', 0);

create or replace table sales(name, quantity)
as select * from values
    ('apples', 10), ('apples', 0),
    ('oranges', 10), ('nuts', 12), ('nuts', 0),
    ('grapes', 25), ('oranges', 20), ('nuts', 15);

select fruits.name, fruits.stock, sales.quantity
  from fruits join sales on fruits.name = sales.name;

-- ==========================================================
-- saving into temporary intermediate table
create or replace temporary table fruits_and_sales
as select fruits.name as name,
    fruits.stock as stock,
    sales.quantity as quantity
  from fruits join sales on fruits.name = sales.name;

select *
  from fruits_and_sales
  where stock > 0 and quantity > 0;

-- ==========================================================
-- with CTEs
with fruits_and_sales as (
  select fruits.name, fruits.stock, sales.quantity
  from fruits join sales on fruits.name = sales.name),
where_filter as (
  select *
  from fruits_and_sales
  where stock > 0 and quantity > 0),
group_by as (
  select name, stock, sum(quantity) as sold 
  from where_filter
  group by name, stock),
having_filter as (
  select *
  from group_by
  where sold < stock),
win_funcs as (
  select *, row_number() over (order by name) as rn
  from having_filter),
qualify_filter as (
  select *
  from win_funcs
  where rn >= 2),
distinct_filter as (
  select name, stock, sold, rn
  from qualify_filter
  group by name, stock, sold, rn),
order_by as (
  select *
  from distinct_filter
  order by sold desc)
select name, sold
from order_by
limit 2;

select $1, $2 from fruits;

-- ==========================================================
-- equivalent, w/ pipe operators
select fruits.name, fruits.stock, sales.quantity
  from fruits join sales on fruits.name = sales.name
  ->> select * from $1
  where stock > 0 and quantity > 0
  ->> select name, stock, sum(quantity) as sold from $1
  group by name, stock
  ->> select * from $1
  where sold < stock
  ->> select *, row_number() over (order by name) as rn from $1
  ->> select * from $1
  where rn >= 2
  ->> select name, stock, sold, rn from $1
  group by name, stock, sold, rn
  ->> select * from $1
  order by sold desc
  ->> select name, sold from $1
  limit 2;

-- ==========================================================
-- from the query result cache
SHOW DATABASES;
SHOW TABLES;

select "name", "created_on"
from TABLE(RESULT_SCAN(LAST_QUERY_ID()));

SHOW DATABASES
  ->> select "name", "created_on" from $1;

SHOW DATABASES
  ->> SHOW TABLES
  ->> select "name", "created_on" from $1;

SHOW DATABASES
  ->> SHOW TABLES
  ->> select "name", "created_on" from $2;

-- ==========================================================
-- w/ DML statements
CREATE OR REPLACE TEMPORARY TABLE t1 (x int)
  ->> INSERT INTO t1 VALUES (1)
  ->> INSERT INTO t1 VALUES (2)
  ->> INSERT INTO t1 VALUES (3)
  ->> SELECT (SELECT $1 FROM $3)
    + (SELECT $1 FROM $2)
    + (SELECT $1 FROM $1) AS count;

BEGIN TRANSACTION
  ->> INSERT INTO t1 VALUES (1)
  ->> DELETE FROM t1 WHERE x=1
  ->> UPDATE t1 SET x=2
  ->> COMMIT
  ->> SELECT (SELECT $1 FROM $4) AS inserted,
    (SELECT $1 FROM $3) AS deleted,
    (SELECT $1 FROM $2) AS updated;
