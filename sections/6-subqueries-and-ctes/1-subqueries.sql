use test.employees;

-- ======================================================
-- Uncorrelated Subqueries

-- in SELECT
SELECT (SELECT count(*) FROM emp);

-- in FROM
SELECT *
FROM (SELECT count(*) FROM emp);

-- in WHERE
SELECT count(*) FROM emp
WHERE 0 < (SELECT count(*) FROM emp);

-- in HAVING
SELECT count(*) FROM emp
HAVING count(*) = (SELECT count(*) FROM emp);

-- in GROUP BY
SELECT count(*) FROM emp
GROUP BY (SELECT count(*) FROM emp);

-- in ORDER BY
SELECT count(*) FROM emp
ORDER BY (SELECT count(*) FROM emp);

-- =====================================================================
-- 2 uncorrelated subqueries
-- show number of employees and salaries, for each department, as a percentage of all
SELECT dept_id, count(*) empsd, sum(salary) salsd
FROM emp
GROUP BY dept_id;

SELECT count(*) emps, sum(salary) sals
FROM emp;

SELECT x.dept_id, empsd/emps "% emps", salsd/sals "% sals"
FROM (
    SELECT dept_id, count(*) empsd, sum(salary) salsd
    FROM emp
	GROUP BY dept_id) x,
	(SELECT count(*) emps, sum(salary) sals
	FROM emp) y;

-- ======================================================
-- Correlated Subqueries

-- in SELECT: get hired date of the employee hired after each employee in the same department
SELECT dept_id, name, hire_date, salary, (
   SELECT min(hire_date) next_hire
   FROM emp d
   WHERE d.dept_id = e.dept_id AND d.hire_date > e.hire_date) mh
FROM emp e
ORDER BY 1, 2;

-- in FROM: get salaries per department
SELECT name, salaries
FROM dept LEFT JOIN (
   SELECT dept_id, sum(salary) as salaries
   FROM	emp
   GROUP BY	1) AS sals
ON sals.dept_id = dept.dept_id
ORDER BY 1;

-- in WHERE: get employees with biggest salary per department (can write w/ max)
SELECT dept_id, name, salary
FROM emp e
WHERE salary >= ALL (
   SELECT salary
   FROM emp d
   WHERE d.dept_id = e.dept_id);
