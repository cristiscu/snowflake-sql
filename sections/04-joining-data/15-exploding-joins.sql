-- see https://medium.com/snowflake/understanding-the-exploding-joins-problem-in-snowflake-6b4f89f006c7
ALTER SESSION SET USE_CACHED_RESULTS = FALSE;

-- no joins
select c1.c_custkey, c1.c_name, c1.c_nationkey, c1.c_acctbal
from customer c1
where c1.c_acctbal > 3000;

-- one-to-one join
select c1.c_name
from customer c1 join customer c2
  on c1.c_custkey = c2.c_custkey
where c1.c_acctbal > 3000;

-- exploding joins
select c1.c_name
from customer c1 join customer c2
  on c1.c_nationkey = c2.c_nationkey
where c1.c_acctbal > 3000;

select GET_QUERY_OPERATOR_STATS(last_query_id());

-- cartesian product (do NOT run!)
explain
    select c1.c_name
    from customer c1, customer c2
    where c1.c_acctbal > 3000;
