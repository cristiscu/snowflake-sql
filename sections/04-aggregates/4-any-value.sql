-- ANY_VALUE
-- https://docs.snowflake.com/en/sql-reference/functions/any_value
use snowflake_sample_data.tpch_sf1;

select n_nationkey,
    count(c_custkey) as cust
from nation
join customer on n_nationkey = c_nationkey
group by n_nationkey
order by cust desc, n_nationkey
limit 10;

-- added country's name
select n_nationkey,
    n_name,
    count(c_custkey) as cust
from nation
join customer on n_nationkey = c_nationkey
group by n_nationkey, n_name
order by cust desc, n_nationkey
limit 10;

-- fix w/ MAX
select n_nationkey,
    MAX(n_name),
    count(c_custkey) as cust
from nation
join customer on n_nationkey = c_nationkey
group by n_nationkey
order by cust desc, n_nationkey
limit 10;

-- better fix w/ ANY_VALUE
select n_nationkey,
    ANY_VALUE(n_name),
    count(c_custkey) as cust
from nation
join customer on n_nationkey = c_nationkey
group by n_nationkey
order by cust desc, n_nationkey
limit 10;

