-- see https://docs.snowflake.com/en/developer-guide/udf/sql/udf-sql-tabular-functions
use test.employees;

-- UDTF in SQL
CREATE OR REPLACE FUNCTION get_employee_names(DID int)
    RETURNS TABLE(name VARCHAR)
AS 'SELECT name FROM emp WHERE dept_id = DID';

select d.name as department, e.name as employee
from dept d, table(get_employee_names(d.dept_id)) e
order by 1, 2;

select d.name as department, e.name as employee
from dept d, lateral get_employee_names(d.dept_id) e
order by 1, 2;

-- built-in UDTFs
-- see https://docs.snowflake.com/en/sql-reference/functions-table
show tables;
select "database_name" || '.' || "schema_name" || '.' || "name" as obj 
from table(result_scan(last_query_id(-2)));

select seq1(), seq2(), seq4(), seq8()
from table(generator(rowcount => 100));

select *
from table(information_schema.warehouse_metering_history(
    dateadd('days', -10, current_date())));
