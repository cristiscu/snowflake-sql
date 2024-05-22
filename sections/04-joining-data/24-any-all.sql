use schema employees.public;

-- see https://docs.snowflake.com/en/sql-reference/operators-subquery
-- ANY
SELECT name FROM dept
WHERE dept_id = ANY (SELECT dept_id FROM emp WHERE salary >= 3000);

-- ANY equivalent
SELECT dept.name as department, emp.name as employee, salary
FROM dept JOIN emp ON dept.dept_id = emp.dept_id
WHERE salary >= 3000;

-- ALL
SELECT name FROM dept
WHERE dept_id != ALL (SELECT dept_id FROM emp WHERE salary >= 3000);

-- ALL emulated
SELECT name FROM dept
WHERE dept_id not in (SELECT dept_id FROM emp WHERE salary >= 3000);
