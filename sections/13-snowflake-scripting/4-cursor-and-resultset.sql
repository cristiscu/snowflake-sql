-- Cursor and ResultSet
-- https://docs.snowflake.com/en/developer-guide/snowflake-scripting/cursors
use test.employees;

table dept;
table emp;

-- for multi-table insert
-- need to create separate tables w/ employees for each department
CREATE OR REPLACE TABLE emp_Accounting AS
    SELECT * EXCLUDE dept_id FROM emp
    WHERE dept_id = 10;
CREATE OR REPLACE TABLE emp_Research AS
    SELECT * EXCLUDE dept_id FROM emp
    WHERE dept_id = 20;
CREATE OR REPLACE TABLE emp_Sales AS
    SELECT * EXCLUDE dept_id FROM emp
    WHERE dept_id = 30;
CREATE OR REPLACE TABLE emp_Operations AS
    SELECT * EXCLUDE dept_id FROM emp
    WHERE dept_id = 40;

BEGIN
    LET cur CURSOR FOR SELECT dept_id, name FROM dept;
    FOR d IN cur DO
        LET dept_id integer := d.dept_id;
        LET table_name string := 'emp_' || d.name;
        CREATE OR REPLACE TABLE IDENTIFIER(:table_name) AS
            SELECT * EXCLUDE dept_id FROM emp
            WHERE dept_id = :dept_id;
    END FOR;
END;

-- alternative w/ DECLARE section and ResultSet
DECLARE
    res RESULTSET DEFAULT (SELECT dept_id, name FROM dept);
    cur CURSOR FOR res;
    dept_id integer default 0;
    table_name string;
BEGIN
    FOR d IN cur DO
        dept_id := d.dept_id;
        table_name := 'emp_' || d.name;
        CREATE OR REPLACE TABLE IDENTIFIER(:table_name) AS
            SELECT * EXCLUDE dept_id FROM emp
            WHERE dept_id = :dept_id;
    END FOR;
END;
table emp_accounting;
table emp_research;
table emp_sales;
table emp_operations;
