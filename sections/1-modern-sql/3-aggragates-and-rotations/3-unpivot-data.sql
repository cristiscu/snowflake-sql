-- see https://docs.snowflake.com/en/sql-reference/constructs/unpivot
use snowflake_sample_data.tpch_sf1;

-- ===================================================
-- emulated UNPIVOT query (from PIVOT)

-- dynamic pivot
select *
from (
    select n_name as country, c_mktsegment
    from customer
    join nation on c_nationkey = n_nationkey)
PIVOT(count(c_mktsegment) for c_mktsegment in (ANY ORDER BY c_mktsegment))
order by 1;

with cte as (
    select *
    from (
        select n_name as country, c_mktsegment
        from customer
        join nation on c_nationkey = n_nationkey)
    PIVOT(count(c_mktsegment) for c_mktsegment in (ANY ORDER BY c_mktsegment))
    order by 1)

SELECT country, 'AUTOMOBILE' as c_mktsegment, "'AUTOMOBILE'" as c FROM cte
UNION ALL SELECT country, 'BUILDING', "'BUILDING'" FROM cte
UNION ALL SELECT country, 'FURNITURE', "'FURNITURE'" FROM cte
UNION ALL SELECT country, 'HOUSEHOLD', "'HOUSEHOLD'" FROM cte
UNION ALL SELECT country, 'MACHINERY', "'MACHINERY'" FROM cte
ORDER BY 1, 2;

-- ===================================================
-- UNPIVOT query (from PIVOT)

with cte as (
    select *
    from (
        select n_name as country, c_mktsegment
        from customer
        join nation on c_nationkey = n_nationkey)
    PIVOT(count(c_mktsegment) for c_mktsegment in (ANY ORDER BY c_mktsegment))
    order by 1)

SELECT country, TRIM(c_mktsegment, '''') as c_mktsegment, c
FROM cte
UNPIVOT (c FOR c_mktsegment IN (
    "'AUTOMOBILE'", "'BUILDING'", "'FURNITURE'", "'HOUSEHOLD'", "'MACHINERY'"));

-- no dynamic unpivot
with cte as (
    select *
    from (
        select n_name as country, c_mktsegment
        from customer
        join nation on c_nationkey = n_nationkey)
    PIVOT(count(c_mktsegment) for c_mktsegment in (ANY ORDER BY c_mktsegment))
    order by 1)

SELECT country, TRIM(c_mktsegment, '''') as c_mktsegment, c
FROM cte
UNPIVOT (c FOR c_mktsegment IN (LISTAGG(SELECT DISTINCT c_mktsegment FROM customer)));
