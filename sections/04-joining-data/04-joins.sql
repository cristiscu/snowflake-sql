use schema test.employees;

-- cross/inner joins
SELECT dept.name as dept, emp.name as emp
FROM dept CROSS JOIN emp;

SELECT dept.name as dept, emp.name as emp
FROM dept, emp;

SELECT dept.name as dept, emp.name as emp
FROM dept CROSS JOIN emp
WHERE dept.dept_id = emp.dept_id;

SELECT dept.name as dept, emp.name as emp
FROM dept INNER JOIN emp
ON dept.dept_id = emp.dept_id;

-- outer/full joins
SELECT dept.name as dept, emp.name as emp
FROM dept LEFT JOIN emp
ON dept.dept_id = emp.dept_id;

SELECT dept.name as dept, emp.name as emp
FROM dept FULL JOIN emp
ON dept.dept_id = emp.dept_id;

-- emulated full join
SELECT dept.name as dept, emp.name as emp
FROM dept LEFT JOIN emp
ON dept.dept_id = emp.dept_id
UNION
SELECT dept.name as dept, emp.name as emp
FROM dept RIGHT JOIN emp
ON dept.dept_id = emp.dept_id;

-- emulated full/right/left exclude joins
SELECT dept.name as dept, emp.name as emp
FROM dept FULL JOIN emp
ON dept.dept_id = emp.dept_id
WHERE dept.dept_id is null or emp.dept_id is null;

SELECT dept.name as dept, emp.name as emp
FROM dept FULL JOIN emp
ON dept.dept_id = emp.dept_id
WHERE emp.dept_id is null;

SELECT dept.name as dept, emp.name as emp
FROM dept FULL JOIN emp
ON dept.dept_id = emp.dept_id
WHERE dept.dept_id is null;

SELECT * FROM dept
WHERE NOT EXISTS (
    SELECT * FROM emp
    WHERE dept_id = dept.dept_id);

SELECT * FROM dept
WHERE dept_id NOT IN (
    SELECT dept_id FROM emp);

-- natural joins (not working!)
SELECT dept.name as dept, emp.name as emp
FROM dept NATURAL JOIN emp;

SELECT dept.name as dept, emp.name as emp
FROM emp NATURAL JOIN dept;
