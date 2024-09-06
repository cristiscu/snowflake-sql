use test.employees;

-- no Operations!
SELECT dept.name as department, e.name as employee
FROM dept
    LEFT JOIN LATERAL (SELECT name FROM emp WHERE emp.dept_id = dept.dept_id) e
ORDER BY 1, 2;

SELECT dept.name as department, e.name as employee
FROM dept,
    LATERAL (SELECT * FROM emp WHERE emp.dept_id = dept.dept_id) e
ORDER BY 1, 2;

-- this will fail
SELECT dept.name as department, e.name as employee
FROM dept,
    (SELECT name FROM emp WHERE emp.dept_id = dept.dept_id) e
ORDER BY 1, 2;

-- ====================================================================
create or replace function get_employees(DID int)
    returns table(employee string)
as 'SELECT name FROM emp WHERE dept_id = DID';

SELECT dept.name as department, e.employee
FROM dept,
    LATERAL get_employees(dept_id) e
ORDER BY 1, 2;

-- ====================================================================
SELECT elem.value
FROM (SELECT ARRAY_CONSTRUCT(1, 2, 3) arr),
    LATERAL FLATTEN(arr) elem;

SELECT elem.value
FROM (SELECT ARRAY_CONSTRUCT(1, 2, 3) arr),
    LATERAL FLATTEN(input => arr, outer => TRUE) elem;

SELECT elem.value
FROM (SELECT ARRAY_CONSTRUCT(1, 2, 3) arr),
    TABLE(FLATTEN(input => arr, outer => TRUE)) elem;
