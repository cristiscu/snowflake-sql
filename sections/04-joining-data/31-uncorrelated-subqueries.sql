use schema test.employees;

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

