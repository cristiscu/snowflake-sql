-- Subquery Operators
-- https://docs.snowflake.com/en/sql-reference/operators-subquery
use test.employees;

-- ==========================================================
-- ANY/SOME
SELECT name
FROM dept
WHERE dept_id = ANY (SELECT dept_id FROM emp WHERE salary >= 3000);

SELECT name
FROM dept
WHERE dept_id = SOME (SELECT dept_id FROM emp WHERE salary >= 3000);

SELECT name
FROM dept
WHERE dept_id >= ANY (SELECT dept_id FROM emp WHERE salary >= 3000);

-- ANY/SOME emulated (with EXISTS)
SELECT name
FROM dept
WHERE EXISTS (SELECT null FROM emp WHERE emp.dept_id = dept.dept_id and salary >= 3000);

SELECT name
FROM dept
WHERE (SELECT null FROM emp WHERE emp.dept_id = dept.dept_id and salary >= 3000) IS NOT NULL;

SELECT DISTINCT dept.name
FROM dept JOIN emp ON dept.dept_id = emp.dept_id
WHERE salary >= 3000;

SELECT DISTINCT dept.name
FROM dept, emp
WHERE dept.dept_id = emp.dept_id and salary >= 3000;

-- ==========================================================
-- ALL
SELECT name
FROM dept
WHERE dept_id != ALL (SELECT dept_id FROM emp WHERE salary >= 3000);

-- ALL emulated (with NOT IN)
-- IN ~= ANY, NOT IN ~= <> ALL
SELECT name
FROM dept
WHERE dept_id NOT IN (SELECT dept_id FROM emp WHERE salary >= 3000);
