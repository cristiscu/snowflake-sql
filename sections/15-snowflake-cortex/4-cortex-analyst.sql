-- Cortex Analyst
-- https://docs.snowflake.com/en/user-guide/snowflake-cortex/cortex-analyst
use test.employees;

-- ===============================================================
-- create semantic view
-- https://docs.snowflake.com/en/user-guide/views-semantic/sql
CREATE OR REPLACE SEMANTIC VIEW tpch_analysis
    TABLES (
        region AS SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.REGION PRIMARY KEY (r_regionkey),
        nation AS SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.NATION PRIMARY KEY (n_nationkey),
        customer AS SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER PRIMARY KEY (c_custkey),
        orders AS SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS PRIMARY KEY (o_orderkey),
        lineitem AS SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.LINEITEM PRIMARY KEY (l_orderkey, l_linenumber),
        supplier AS SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.SUPPLIER PRIMARY KEY (s_suppkey))
    RELATIONSHIPS (
        nation   (n_regionkey) REFERENCES region,
        customer (c_nationkey) REFERENCES nation,
        orders   (o_custkey)   REFERENCES customer,
        lineitem (l_orderkey)  REFERENCES orders,
        supplier (s_nationkey) REFERENCES nation)
    FACTS (
        region.r_name AS r_name,
        nation.n_name AS n_name,
        orders.o_orderkey AS o_orderkey,
        customer.c_customer_order_count AS COUNT(orders.o_orderkey),
        lineitem.line_item_id AS CONCAT(l_orderkey, '-', l_linenumber),
        orders.count_line_items AS COUNT(lineitem.line_item_id))
    DIMENSIONS (
        nation.nation_name AS n_name,
        customer.customer_name AS c_name,
        customer.customer_region_name AS region.r_name,
        customer.customer_nation_name AS nation.n_name,
        customer.customer_market_segment AS c_mktsegment,
        customer.customer_country_code AS LEFT(c_phone, 2),
        orders.order_date AS orders.o_orderdate)
    METRICS (
        customer.customer_count AS COUNT(c_custkey),
        customer.customer_order_count AS SUM(c_customer_order_count),
        orders.order_count AS COUNT(o_orderkey),
        orders.order_average_value AS AVG(orders.o_totalprice),
        orders.average_line_items_per_order AS AVG(orders.count_line_items),
        supplier.supplier_count AS COUNT(s_suppkey));

-- ===============================================================
-- query semantic views
-- https://docs.snowflake.com/en/user-guide/views-semantic/querying
SELECT customer_market_segment, AGG(order_average_value)
FROM tpch_analysis
GROUP BY customer_market_segment
ORDER BY customer_market_segment;

SELECT *
FROM SEMANTIC_VIEW(
    tpch_analysis
    DIMENSIONS customer.customer_market_segment as segment
    METRICS orders.order_average_value average)
ORDER BY segment;

SELECT * 
FROM SEMANTIC_VIEW(
    tpch_analysis
    DIMENSIONS customer.customer_name
    FACTS customer.c_customer_order_count)
ORDER BY customer_name
LIMIT 5;

SELECT * 
FROM SEMANTIC_VIEW(
    tpch_analysis
    DIMENSIONS DATE_PART('year', orders.order_date) AS year)
ORDER BY year;

SELECT *
FROM SEMANTIC_VIEW(
    tpch_analysis
    FACTS customer.c_customer_order_count
    WHERE orders.order_date < '2021-01-01'
        AND region.r_name = 'AMERICA');

