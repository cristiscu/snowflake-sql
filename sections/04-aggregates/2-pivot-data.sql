-- PIVOT Queries
-- https://docs.snowflake.com/en/sql-reference/constructs/pivot
use snowflake_sample_data.tpch_sf1;

-- ===================================================
-- emulated PIVOT query

select distinct c_mktsegment
from customer
order by c_mktsegment;

select n_name as country, c_mktsegment, count(*)
from customer join nation on c_nationkey = n_nationkey
group by n_name, c_mktsegment
order by n_name, c_mktsegment;

select n_name as country,
    sum(case c_mktsegment when 'AUTOMOBILE' then 1 else 0 end) as AUTOMOBILE,
    sum(case c_mktsegment when 'BUILDING' then 1 else 0 end) as BUILDING,
    sum(case c_mktsegment when 'FURNITURE' then 1 else 0 end) as FURNITURE,
    sum(case c_mktsegment when 'HOUSEHOLD' then 1 else 0 end) as HOUSEHOLD,
    sum(case c_mktsegment when 'MACHINERY' then 1 else 0 end) as MACHINERY
from customer join nation on c_nationkey = n_nationkey
group by n_name
order by n_name;

select n_name as country,
    sum(IFF(c_mktsegment = 'AUTOMOBILE', 1, 0)) as AUTOMOBILE,
    sum(IFF(c_mktsegment = 'BUILDING', 1, 0)) as BUILDING,
    sum(IFF(c_mktsegment = 'FURNITURE', 1, 0)) as FURNITURE,
    sum(IFF(c_mktsegment = 'HOUSEHOLD', 1, 0)) as HOUSEHOLD,
    sum(IFF(c_mktsegment = 'MACHINERY', 1, 0)) as MACHINERY
from customer join nation on c_nationkey = n_nationkey
group by n_name
order by n_name;

select n_name as country,
    sum((c_mktsegment = 'AUTOMOBILE')::int) as AUTOMOBILE,
    sum((c_mktsegment = 'BUILDING')::int) as BUILDING,
    sum((c_mktsegment = 'FURNITURE')::int) as FURNITURE,
    sum((c_mktsegment = 'HOUSEHOLD')::int) as HOUSEHOLD,
    sum((c_mktsegment = 'MACHINERY')::int) as MACHINERY
from customer join nation on c_nationkey = n_nationkey
group by n_name
order by n_name;

select n_name as country,
    count_if(c_mktsegment = 'AUTOMOBILE') as AUTOMOBILE,
    count_if(c_mktsegment = 'BUILDING') as BUILDING,
    count_if(c_mktsegment = 'FURNITURE') as FURNITURE,
    count_if(c_mktsegment = 'HOUSEHOLD') as HOUSEHOLD,
    count_if(c_mktsegment = 'MACHINERY') as MACHINERY
from customer join nation on c_nationkey = n_nationkey
group by n_name
order by n_name;

-- emulated PIVOT w/ 2+ rotated columns
select n_name as country,
    count_if(c_mktsegment = 'AUTOMOBILE' and c_acctbal >= 0) as AUTOMOBILE_PLUS,
    count_if(c_mktsegment = 'AUTOMOBILE' and c_acctbal < 0) as AUTOMOBILE_MINUS,
    count_if(c_mktsegment = 'BUILDING' and c_acctbal >= 0) as BUILDING_PLUS,
    count_if(c_mktsegment = 'BUILDING' and c_acctbal < 0) as BUILDING_MINUS
from customer join nation on c_nationkey = n_nationkey
group by n_name
order by n_name;

-- emulated PIVOT w/ 2+ grouped columns
select r_name as region, n_name as country,
    count_if(c_mktsegment = 'AUTOMOBILE' and c_acctbal >= 0) as AUTOMOBILE_PLUS,
    count_if(c_mktsegment = 'AUTOMOBILE' and c_acctbal < 0) as AUTOMOBILE_MINUS,
    count_if(c_mktsegment = 'BUILDING' and c_acctbal >= 0) as BUILDING_PLUS,
    count_if(c_mktsegment = 'BUILDING' and c_acctbal < 0) as BUILDING_MINUS
from customer
    join nation on c_nationkey = n_nationkey
    join region on n_regionkey = r_regionkey
group by r_name, n_name
order by r_name, n_name;

-- ======================================================
-- PIVOT queries

select n_name as country,
    "'AUTOMOBILE'", "'BUILDING'"
from customer
    join nation on c_nationkey = n_nationkey
PIVOT(count(c_mktsegment) for c_mktsegment in ('AUTOMOBILE', 'BUILDING'))
order by 1;

select country,
    "'AUTOMOBILE'" as AUTOMOBILE, "'BUILDING'" as BUILDING
from (
    select n_name as country, c_mktsegment
    from customer
    join nation on c_nationkey = n_nationkey)
PIVOT(count(c_mktsegment) for c_mktsegment in ('AUTOMOBILE', 'BUILDING'))
order by 1;

-- PIVOT w/ 2+ grouped columns
select region, country,
    "'AUTOMOBILE'" as AUTOMOBILE, "'BUILDING'" as BUILDING
from (
    select r_name as region, n_name as country, c_mktsegment
    from customer
    join nation on c_nationkey = n_nationkey
    join region on r_regionkey = n_regionkey)
PIVOT(count(c_mktsegment) for c_mktsegment in ('AUTOMOBILE', 'BUILDING'))
order by 1, 2;

-- dynamic PIVOT w/ values from subquery
select country,
    "'AUTOMOBILE'" as AUTOMOBILE, "'BUILDING'" as BUILDING
from (
    select n_name as country, c_mktsegment
    from customer
    join nation on c_nationkey = n_nationkey)
PIVOT(count(c_mktsegment) for c_mktsegment in (
    select distinct c_mktsegment from customer))
order by 1;

-- dynamic PIVOT w/ ANY (implied values)
select country,
    "'AUTOMOBILE'" as AUTOMOBILE, "'BUILDING'" as BUILDING
from (
    select n_name as country, c_mktsegment
    from customer
    join nation on c_nationkey = n_nationkey)
PIVOT(count(c_mktsegment) for c_mktsegment in (ANY))
order by 1;

-- dynamic PIVOT w/ ANY (implied values)
select *
from (
    select n_name as country, c_mktsegment
    from customer
    join nation on c_nationkey = n_nationkey)
PIVOT(count(c_mktsegment) for c_mktsegment in (ANY ORDER BY c_mktsegment))
order by 1;

-- dynamic pivot w/ different aggregate and value column
select *
from (
    select n_name as country, c_acctbal, c_mktsegment
    from customer
    join nation on c_nationkey = n_nationkey)
PIVOT(sum(c_acctbal) for c_mktsegment in (ANY ORDER BY c_mktsegment))
order by 1;
