-- TABLE vs LATERAL
-- https://docs.snowflake.com/en/sql-reference/literals-table
use snowflake_sample_data.tpch_sf1;

select ah.query_id, ah.objects_modified oms, om.value
from snowflake.account_usage.access_history ah,
    table(flatten(oms)) om
where array_size(oms) > 1
limit 10;

select ah.query_id, ah.objects_modified oms, om.value
from snowflake.account_usage.access_history ah,
    lateral flatten(oms) om
where array_size(oms) > 1
limit 10;
