use snowflake_sample_data.tpch_sf1;

select n_name, (
    select count(c_custkey)
    from customer
    where n.n_nationkey = c_nationkey) cust
from nation n
order by cust desc, n_name
limit 10;

select n_name, count(c_custkey) as cust
from nation
join customer on n_nationkey = c_nationkey
group by n_name
order by cust desc, n_name
limit 10;

select n_name, cust
from nation n
join (
    select count(c_custkey) cust
    from customer
    where n.n_nationkey = c_nationkey) c
group by n_name, cust
order by cust desc, n_name
limit 10;

-- ====================================================================

select r_name, n_name
from region r
left join nation on r_regionkey = n_regionkey
order by 1, 2;

select r_name, n_name
from region r
left join (
    select n_name
    from nation
    where r.r_regionkey = n_regionkey)
order by 1, 2;

-- ====================================================================

SELECT elem.value
FROM (SELECT ARRAY_CONSTRUCT(1, 2, 3) arr),
    LATERAL FLATTEN(arr) elem;

SELECT elem.value
FROM (SELECT ARRAY_CONSTRUCT(1, 2, 3) arr),
    LATERAL FLATTEN(input => arr, outer => TRUE) elem;

SELECT elem.value
FROM (SELECT ARRAY_CONSTRUCT(1, 2, 3) arr),
    TABLE(FLATTEN(input => arr, outer => TRUE)) elem;
