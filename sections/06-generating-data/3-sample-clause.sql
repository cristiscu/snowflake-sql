-- SAMPLE/TABLESAMPLE
-- https://docs.snowflake.com/en/sql-reference/constructs/sample

-- ==================================================
-- 10 rows from small table
select *
from test.employees.emp;

select *
from test.employees.emp
limit 10;

select *
from test.employees.emp
SAMPLE ROW (10 ROWS);

-- ==================================================
-- 10% from large table
-- https://docs.snowflake.com/en/sql-reference/functions/approx_count_distinct
SELECT APPROX_COUNT_DISTINCT(*)
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.LINEITEM;

SELECT HLL(*)
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.LINEITEM;

SELECT *
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.LINEITEM
TABLESAMPLE (10);