-- Table Constraints
-- https://medium.com/snowflake/how-to-reverse-engineer-a-snowflake-database-schema-3d62ca208993
-- https://medium.com/snowflake/how-to-generate-erds-from-a-snowflake-model-3fc53abd0669
-- https://docs.snowflake.com/en/sql-reference/constraints-overview
use test.employees;

SHOW DATABASES;
SHOW SCHEMAS IN DATABASE test;
SHOW TABLES IN SCHEMA test.employees;
SHOW COLUMNS IN SCHEMA test.employees;
SHOW UNIQUE KEYS IN SCHEMA test.employees;
SHOW PRIMARY KEYS IN SCHEMA test.employees;
SHOW IMPORTED KEYS IN SCHEMA test.employees;
