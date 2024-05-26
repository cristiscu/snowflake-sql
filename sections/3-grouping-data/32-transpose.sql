use test.employees;

SELECT status, sum(salary) as salaries
FROM emp
GROUP BY status;

-- TODO!
SELECT *
FROM (
    SELECT status, salary
    FROM emp
    UNPIVOT (salaries FOR status IN ("'divorced'", "'married'", "'single'", "NULL"))
)
PIVOT (
  sum(salary) FOR status IN ("'divorced'", "'married'", "'single'", "NULL")
);