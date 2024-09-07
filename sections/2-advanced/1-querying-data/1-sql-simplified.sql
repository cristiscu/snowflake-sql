-- no FROM dual
select 1, current_timestamp(), current_timestamp;

select 1
where 1=1
group by 1
having 1=1
order by 1;

-- $1 returns NULL if no FROM
select $1;

select $1
from snowflake_sample_data.tpch_sf1.lineitem
limit 10;

use snowflake_sample_data.tpch_sf1;

-- no required FROM alias
select c
from (select count(*) as c from lineitem);

-- ==============================================================
-- no required ON (could use WHERE instead)
select region.r_name, nation.n_name
from region left join nation
    on region.r_regionkey = nation.n_regionkey
order by 1, 2;

select region.r_name, nation.n_name
from region left join nation
where region.r_regionkey = nation.n_regionkey
order by 1, 2;

select r_name, n_name
from region r left join 
    (select n_name from nation where r.r_regionkey = n_regionkey)
    on true
order by 1, 2;

select r_name, n_name
from region r left join lateral 
    (select n_name from nation where r.r_regionkey = n_regionkey)
    -- on true
order by 1, 2;
