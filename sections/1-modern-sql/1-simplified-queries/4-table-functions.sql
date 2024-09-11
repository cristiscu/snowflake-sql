-- see https://docs.snowflake.com/en/sql-reference/literals-table
-- see https://docs.snowflake.com/en/user-guide/sample-data-tpch
use snowflake_sample_data.tpch_sf1;

select *
from lineitem;

SELECT SYSTEM$EXPLAIN_PLAN_JSON(LAST_QUERY_ID());

SELECT PARSE_JSON(SYSTEM$EXPLAIN_PLAN_JSON(LAST_QUERY_ID(-2)));

ALTER SESSION SET USE_CACHED_RESULT = FALSE;

select *
from lineitem
limit 10;

-- =================================================
-- TABLE statement
table lineitem
limit 10;

select *
from table('lineitem')
limit 10;

set name = 'lineitem';
select *
from table($name)
limit 10;

select *
from identifier('lineitem')
limit 10;

select identifier('l_orderkey')
from identifier('lineitem')
limit 10;

-- =================================================
-- table functions
select *
from table(result_scan(last_query_id()))
limit 10;

select *
from result_scan(last_query_id())
limit 10;
