use snowflake_sample_data.tpch_sf1;

select l_extendedprice
from lineitem;

-- mean/mode/median
select avg(l_extendedprice) as mean,
    mode(l_extendedprice) as mode,
    median(l_extendedprice) as median
from lineitem;

-- skew/kurtosis
select skew(l_extendedprice),
    kurtosis(l_extendedprice)
from lineitem;

-- WIDTH_BUCKET histogram
select l_extendedprice,
    width_bucket(l_extendedprice, 0, 120000, 100) as buckets
from lineitem
order by l_orderkey desc
limit 100000;

-- show as scatter chart
select l_quantity, l_extendedprice
from lineitem
order by l_orderkey desc
limit 10000;

-- strong positive correlation
select corr(l_quantity, l_extendedprice)
from lineitem;

-- det slope+intercept
select regr_slope(l_quantity, l_extendedprice) slope,
    regr_intercept(l_quantity, l_extendedprice) intercept,
    regr_r2(l_quantity, l_extendedprice) r2
from lineitem;

-- make a prediction (w/ linear regression)
with cte as (
    select regr_slope(l_quantity, l_extendedprice) slope,
        regr_intercept(l_quantity, l_extendedprice) intercept
    from lineitem)
select 130000 as price,
    price * slope + intercept as pred_quantity
from cte;
