use snowflake_sample_data.tpch_sf1;

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
