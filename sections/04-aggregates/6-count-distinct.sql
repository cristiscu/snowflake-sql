-- COUNT(DISTINCT expr) vs ARRAY_SIZE(ARRAY_UNIQUE_AGG(expr))
-- could be faster for multiple GROUPING SETS/ROLLUP/CUBE
-- see https://docs.snowflake.com/en/user-guide/querying-arrays-for-distinct-counts
use SNOWFLAKE_SAMPLE_DATA.TPCH_SF1000;

-- ============================================================
-- 51 seconds
SELECT DISTINCT l_shipmode
FROM lineitem;

-- 34 seconds (slightly faster)
SELECT ARRAY_UNIQUE_AGG(l_shipmode)
FROM lineitem;

-- ============================================================
-- 11 seconds (micro-partition! great pruning!)
SELECT COUNT(DISTINCT l_shipmode)
FROM lineitem;

-- 35 seconds (slower)
SELECT ARRAY_SIZE(ARRAY_UNIQUE_AGG(l_shipmode))
FROM lineitem;

-- ============================================================
-- 92 seconds
SELECT l_returnflag, l_discount, COUNT(DISTINCT l_shipmode)
FROM lineitem
GROUP BY ALL;

-- 94 seconds (~the same)
SELECT l_returnflag, l_discount, ARRAY_SIZE(ARRAY_UNIQUE_AGG(l_shipmode))
FROM lineitem
GROUP BY ALL;

-- ============================================================
-- 206 seconds
SELECT l_returnflag, l_discount, COUNT(DISTINCT l_shipmode)
FROM lineitem
GROUP BY ROLLUP (l_returnflag, l_discount);

-- 96 seconds (much faster!)
SELECT l_returnflag, l_discount, ARRAY_SIZE(ARRAY_UNIQUE_AGG(l_shipmode))
FROM lineitem
GROUP BY ROLLUP (l_returnflag, l_discount);
