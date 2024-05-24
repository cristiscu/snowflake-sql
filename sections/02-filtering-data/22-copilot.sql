use schema employees.public;

select * from emp;

-- target query
SELECT dept_id, sum(salary) as salaries
FROM emp
WHERE status <> 'single'
GROUP BY dept_id
HAVING salaries > 6000
ORDER BY dept_id;

// From table @EMP, I want the sum of salaries @salary per department, as 'salaries',
// grouped and sorted by the department_id @dept_id.
SELECT
  SUM(emp.salary) AS salaries,
  emp.dept_id
FROM
  emp
GROUP BY
  emp.dept_id
ORDER BY
  emp.dept_id;

// From previous query, select only entries with @status not equal to 'single',
// and groups with @salaries greater than 6000
SELECT
  SUM(emp.salary) AS salaries,
  emp.dept_id
FROM
  emp
WHERE
  emp.status ILIKE '%single%'       // must correct this!
GROUP BY
  emp.dept_id
HAVING
  SUM(emp.salary) > 6000
ORDER BY
  emp.dept_id;
