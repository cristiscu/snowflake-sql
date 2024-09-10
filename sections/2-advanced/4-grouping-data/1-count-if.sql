use snowflake_sample_data.tpch_sf1;

select
    (select count(*) from customer
        where c_acctbal >= 0) tot_good_paying,
    (select count(*) from customer
        where c_acctbal < 0) tot_bad_paying;

select n_name as country,
    (select count(*) from customer
        where n.n_nationkey = c_nationkey
        and c_acctbal >= 0) good_paying,
    (select count(*) from customer
        where n.n_nationkey = c_nationkey
        and c_acctbal < 0) bad_paying
from nation n
order by n_name;

select c_nationkey,
    (select count(*) from customer
        where c.c_nationkey = c_nationkey
        and c_acctbal >= 0) good_paying,
    (select count(*) from customer
        where c.c_nationkey = c_nationkey
        and c_acctbal < 0) bad_paying
from customer c
group by c_nationkey
order by c_nationkey;

-- COUNT w/ SUM
select c_nationkey,
    sum(case when c_acctbal >= 0 then 1 else 0 end) as good_paying,
    sum(case when c_acctbal < 0 then 1 else 0 end) as bad_paying
from customer c
group by c_nationkey
order by c_nationkey;

-- COUNT_IF
select c_nationkey,
    count_if(c_acctbal >= 0) as good_paying,
    count_if(c_acctbal < 0) as bad_paying
from customer c
group by c_nationkey
order by c_nationkey;

-- ===================================================
-- emulated PIVOT query

select distinct c_mktsegment
from customer
order by c_mktsegment;

select c_mktsegment,
    sum(case c_mktsegment when 'AUTOMOBILE' then 1 else 0 end) as AUTOMOBILE,
    sum(case c_mktsegment when 'BUILDING' then 1 else 0 end) as BUILDING,
    sum(case c_mktsegment when 'FURNITURE' then 1 else 0 end) as FURNITURE,
    sum(case c_mktsegment when 'HOUSEHOLD' then 1 else 0 end) as HOUSEHOLD,
    sum(case c_mktsegment when 'MACHINERY' then 1 else 0 end) as MACHINERY
from customer c
group by c_mktsegment
order by c_mktsegment;

select c_mktsegment,
    sum(IFF(c_mktsegment = 'AUTOMOBILE', 1, 0)) as AUTOMOBILE,
    sum(IFF(c_mktsegment = 'BUILDING', 1, 0)) as BUILDING,
    sum(IFF(c_mktsegment = 'FURNITURE', 1, 0)) as FURNITURE,
    sum(IFF(c_mktsegment = 'HOUSEHOLD', 1, 0)) as HOUSEHOLD,
    sum(IFF(c_mktsegment = 'MACHINERY', 1, 0)) as MACHINERY
from customer c
group by c_mktsegment
order by c_mktsegment;

select c_mktsegment,
    sum((c_mktsegment = 'AUTOMOBILE')::int) as AUTOMOBILE,
    sum((c_mktsegment = 'BUILDING')::int) as BUILDING,
    sum((c_mktsegment = 'FURNITURE')::int) as FURNITURE,
    sum((c_mktsegment = 'HOUSEHOLD')::int) as HOUSEHOLD,
    sum((c_mktsegment = 'MACHINERY')::int) as MACHINERY
from customer c
group by c_mktsegment
order by c_mktsegment;

select c_mktsegment,
    count_if(c_mktsegment = 'AUTOMOBILE') as AUTOMOBILE,
    count_if(c_mktsegment = 'BUILDING') as BUILDING,
    count_if(c_mktsegment = 'FURNITURE') as FURNITURE,
    count_if(c_mktsegment = 'HOUSEHOLD') as HOUSEHOLD,
    count_if(c_mktsegment = 'MACHINERY') as MACHINERY
from customer c
group by c_mktsegment
order by c_mktsegment;

