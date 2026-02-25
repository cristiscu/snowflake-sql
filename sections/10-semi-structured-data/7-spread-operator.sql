-- Expansion Spread Operator (**)
-- https://docs.snowflake.com/en/sql-reference/operators-expansion
-- https://www.snowflake.com/en/engineering-blog/sql-spread-operator/
use test.employyes;

CREATE OR REPLACE TABLE spread_demo (col1 INT, col2 VARCHAR);
INSERT INTO spread_demo VALUES
  (1, 'a'),
  (2, 'b'),
  (3, 'c'),
  (4, 'd'),
  (5, 'e');
SELECT * FROM spread_demo;

-- in an IN clause
SELECT * FROM spread_demo
  WHERE col1 IN (** [3, 4])
  ORDER BY col1;

SELECT * FROM spread_demo
  WHERE col2 IN (** ['b', 'd'])
  ORDER BY col1;

SELECT * FROM spread_demo
  WHERE col1 IN (** [1, 2], ** [4], 5)
  ORDER BY col1;

-- as var args in a system-defined function call
SELECT COALESCE(** [NULL, NULL, 'my_string_1', 'my_string_2']) AS first_non_null;

SELECT GREATEST(** [1, 2, 5, 4, 5]) AS greatest_value;

-- with a bind variable in a SQL user-defined function
CREATE OR REPLACE FUNCTION spread_function_demo(col_1_values ARRAY)
  RETURNS TABLE(col1 INT, col2 VARCHAR)
AS $$
  SELECT * FROM spread_demo
    WHERE col1 IN (** col_1_values)
    ORDER BY col1
$$;
SELECT * FROM TABLE(spread_function_demo([1, 3, 5]));

-- with a bind variable in a Snowflake Scripting stored procedure
CREATE OR REPLACE PROCEDURE spread_sp_demo(col_1_values ARRAY)
  RETURNS TABLE(col1 INT, col2 VARCHAR)
  LANGUAGE SQL
AS $$
DECLARE
  res RESULTSET;
BEGIN
  res := (SELECT * FROM spread_demo
    WHERE col1 IN (** :col_1_values)
    ORDER BY col1);
  RETURN TABLE(res);
END;
$$;
CALL spread_sp_demo([2, 4]);