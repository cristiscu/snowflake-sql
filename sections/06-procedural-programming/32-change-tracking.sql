use test.employees;

-- source (table) --> target (table), w/ CHANGE_TRACKING
CREATE OR REPLACE TABLE cust_source(id INT, name STRING);
ALTER TABLE source SET CHANGE_TRACKING = TRUE;

-- set initial point in time
SET ts1 = (SELECT CURRENT_TIMESTAMP());

-- 3 x INSERT
INSERT INTO cust_source
    VALUES (1, 'John'), (2, 'Mary'), (3, 'George');

-- UPDATE + INSERT
UPDATE cust_source
    SET name = 'Mark'
    WHERE id = 1;
DELETE FROM cust_source WHERE id = 2;

-- see all INSERTs
SELECT *
FROM cust_source
CHANGES (INFORMATION => APPEND_ONLY) AT (TIMESTAMP => $ts1);

SELECT *
FROM cust_source
CHANGES (INFORMATION => DEFAULT) AT (TIMESTAMP => $ts1);

-- create target with all changes
CREATE OR REPLACE TABLE cust_target AS
    SELECT id, name
    FROM cust_source
    CHANGES (INFORMATION => DEFAULT) AT (TIMESTAMP => $ts1);
SELECT * FROM cust_target;
