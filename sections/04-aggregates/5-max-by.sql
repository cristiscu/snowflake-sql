-- MAX/MIN_BY: get first order (no duplicates)/first N orders with max price per priority status
-- see https://docs.snowflake.com/en/sql-reference/functions/max_by
use snowflake_sample_data.tpch_sf1;

-- distinct category values
select distinct o_orderpriority
from orders o
order by 1;

-- first order with max price per priority status
select o_orderpriority, o_orderkey, o_totalprice,
    (select max(o_totalprice)
    from orders
    where o_orderpriority = o.o_orderpriority) as max_price
from orders o
order by 1, 3 desc;

with cte as (
    select o_orderpriority as priority, max(o_totalprice) as max_price
    from orders
    group by 1)
select o_orderpriority, o_orderkey, max_price
from orders join cte on o_orderpriority = priority
where o_totalprice = max_price
order by 1, 2;

select o_orderpriority, max_by(o_orderkey, o_totalprice) as orderkey
from orders
group by 1
order by 1;

select o_orderpriority,
    any_value(o_orderkey) as o_orderkey,
    max(o_totalprice) over (partition by o_orderpriority order by o_totalprice desc) as max_price
from orders o
group by 1, o_totalprice
qualify o_totalprice = max_price
order by 1;

select distinct o_orderpriority,
    first_value(o_orderkey) over (partition by o_orderpriority order by o_totalprice desc) as orderkey
from orders
order by 1;

-- ==================================================
-- MAX_BY 1

-- ~MAX(o_totalprice)
select o_orderpriority, MAX_BY(o_totalprice, o_totalprice) as max_price
from orders
group by 1
order by 1;

select o_orderpriority, MAX_BY(o_orderkey, o_totalprice) as orderkey
from orders
group by 1
order by 1;

-- ==================================================
-- MAX_BY N

-- first N orders (3) with max price per priority status
select o_orderpriority, MAX_BY(o_orderkey, o_totalprice, 3) as orderkeys
from orders
group by 1;

with cte as (
    select o_orderpriority, MAX_BY(o_orderkey, o_totalprice, 3) as orderkeys
    from orders
    group by 1)
select o_orderpriority, k.value as orderkey
from cte, table(flatten(orderkeys)) k;

select o_orderpriority,
    MIN_BY(o_orderkey, o_totalprice, 3) as orderkeys_min,
    MAX_BY(o_orderkey, o_totalprice, 3) as orderkeys_max
from orders
group by 1;
