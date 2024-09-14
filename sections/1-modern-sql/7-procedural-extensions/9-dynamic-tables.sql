-- see https://docs.snowflake.com/en/sql-reference/sql/create-dynamic-table
use test.employees;

-- source (table) --> target (dynamic table)
CREATE OR REPLACE TABLE cust_source(id INT, name STRING);

DROP TABLE IF EXISTS cust_target;
CREATE OR REPLACE DYNAMIC TABLE cust_target
  WAREHOUSE = compute_wh
  TARGET_LAG = '1 minute'
AS
  SELECT id, name FROM cust_source;

-- insert 3 rows in the source table
INSERT INTO cust_source
    VALUES (1, 'John'), (2, 'Mary'), (3, 'George');
SELECT * FROM cust_target;

-- update+delete existing source rows --> dynamic table should reflect in-place changes
UPDATE cust_source SET name = 'Mark' WHERE id = 1;
DELETE FROM cust_source WHERE id = 2;
SELECT * FROM cust_target;

-- do not forget to suspend the dynamic table when done (or it will consume credits!)
ALTER DYNAMIC TABLE cust_target SUSPEND;
