-- see https://medium.com/snowflake/how-qualify-works-with-in-depth-explanation-and-examples-bbde9fc742db
use snowflake_sample_data.tpch_sf1;

-- no FROM dual
select 1;

select 1
group by 1
having 1=1;

-- $1 returns NULL if no FROM
select $1;

select $1
from lineitem
limit 10;

-- no required FROM alias
SELECT C
FROM (SELECT COUNT(*) AS C FROM lineitem);

-- no required ON (could use WHERE instead)
select region.r_name, nation.n_name
from region left join nation
    on region.R_REGIONKEY = nation.n_regionkey
order by 1, 2;

select region.r_name, nation.n_name
from region left join nation
where region.R_REGIONKEY = nation.n_regionkey
order by 1, 2;

-- reused aliases (as intermediate expressions)
SELECT r_regionkey * 10 as pid, lower(r_name) as name
FROM region
WHERE (r_regionkey * 10) >= 20
GROUP BY r_regionkey * 10, lower(r_name)
HAVING sum(r_regionkey * 10) >= 20
ORDER BY lower(r_name) DESC;

SELECT r_regionkey * 10 as pid, lower(r_name) as name
FROM region
WHERE pid >= 20
GROUP BY pid, name
HAVING sum(pid) >= 20
ORDER BY name DESC;

select ah.query_id, ah.objects_modified oms, om.value
from snowflake.account_usage.access_history ah,
    table(flatten(oms)) om
where array_size(oms) > 1
limit 10;
