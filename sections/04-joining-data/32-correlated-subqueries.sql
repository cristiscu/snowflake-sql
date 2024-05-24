use schema test.employees;

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
