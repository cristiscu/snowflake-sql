-- SELECT * Extensions (to Incllude/Exclude Columns)
-- https://docs.snowflake.com/en/sql-reference/sql/select#selecting-all-columns
-- https://medium.com/snowflake/snowflake-supports-select-ilike-replace-fc71aacd7ef1
use snowflake_sample_data.tpch_sf1;

select *
from lineitem
limit 10;

-- EXCLUDE
select * exclude L_COMMENT
from lineitem
limit 10;

select *
    exclude (L_COMMENT, L_PARTKEY)
    rename L_ORDERKEY as k
from lineitem
limit 10;

-- ILIKE
select * ilike 'L_S%'
from lineitem
limit 10;

select *
    ilike 'L_S%'
    replace('ship-' || L_SUPPKEY as L_SHIPMODE)
from lineitem
limit 10;

select *
    ilike 'L_S%'
    replace('ship-' || L_SUPPKEY as L_SHIPMODE)
    rename L_SHIPMODE as newship
from lineitem
limit 10;
