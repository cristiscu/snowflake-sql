-- Reused Expressions
use snowflake_sample_data.tpch_sf1;

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
