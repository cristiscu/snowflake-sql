-- see https://medium.com/snowflake/how-qualify-works-with-in-depth-explanation-and-examples-bbde9fc742db

-- no FROM dual
select 1;

select 1
group by 1
having 1 = 1;

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

-- ==============================================================
-- reused aliases (as intermediate expressions)
SELECT r_regionkey * 10 as id, lower(r_name) as name
FROM region
WHERE (r_regionkey * 10) >= 20
GROUP BY r_regionkey * 10, lower(r_name)
HAVING sum(r_regionkey * 10) >= 20
ORDER BY lower(r_name) DESC;

SELECT r_regionkey * 10 as id, lower(r_name) as name
FROM region
WHERE id >= 20
GROUP BY id, name
HAVING sum(id) >= 20
ORDER BY name DESC;
