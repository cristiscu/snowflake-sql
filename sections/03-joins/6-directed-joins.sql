-- Directed Joins
-- https://medium.com/@pascalpfffle/directed-joins-in-snowflake-when-forcing-join-order-pays-off-6aad88afec6a
use snowflake_sample_data.tpch_sf1;

-- ================================================================
-- customer --> orders --> lineitem
select c_name, o_orderkey, l_linenumber
from orders
    join customer on c_custkey = o_custkey
    join lineitem on o_orderkey = l_orderkey
limit 1000;

-- orders --> customer --> lineitem
select c_name, o_orderkey, l_linenumber
from orders
    inner directed join customer on c_custkey = o_custkey
    inner directed join lineitem on o_orderkey = l_orderkey
limit 1000;

-- ================================================================
-- customer --> orders --> lineitem
select c_name, o_orderkey, l_linenumber
from orders
    left join customer on c_custkey = o_custkey
    left join lineitem on o_orderkey = l_orderkey
limit 1000;

-- orders --> customer --> lineitem
select c_name, o_orderkey, l_linenumber
from orders
    left directed join customer on c_custkey = o_custkey
    left directed join lineitem on o_orderkey = l_orderkey
limit 1000;
