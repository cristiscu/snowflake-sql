use test.employees;

-- see https://docs.snowflake.com/en/sql-reference/operators-subquery
-- ANY
SELECT name FROM dept
WHERE dept_id = ANY (SELECT dept_id FROM emp WHERE salary >= 3000);

-- ANY emulated (with EXISTS)
SELECT name FROM dept
WHERE EXISTS (SELECT null FROM emp WHERE emp.dept_id = dept.dept_id and salary >= 3000);

SELECT dept.name as department, emp.name as employee, salary
FROM dept JOIN emp ON dept.dept_id = emp.dept_id
WHERE salary >= 3000;

-- ALL
SELECT name FROM dept
WHERE dept_id != ALL (SELECT dept_id FROM emp WHERE salary >= 3000);

-- ALL emulated (with NOT IN)
SELECT name FROM dept
WHERE dept_id NOT IN (SELECT dept_id FROM emp WHERE salary >= 3000);
