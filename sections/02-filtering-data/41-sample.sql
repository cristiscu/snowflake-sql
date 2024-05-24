use schema test.employees;

-- 10 rows from small table
select * from emp;

select * from emp
limit 10;

select * from emp
sample row (10 rows);

-- 10% from large table
SELECT approx_count_distinct(*)
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.LINEITEM;

SELECT *
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.LINEITEM
TABLESAMPLE (10);