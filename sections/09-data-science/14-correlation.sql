use snowflake_sample_data.tpch_sf1;

-- show as scatter chart
select l_quantity, l_extendedprice
from lineitem
order by l_orderkey desc
limit 10000;

-- strong positive correlation (see also SiS heatmap)
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