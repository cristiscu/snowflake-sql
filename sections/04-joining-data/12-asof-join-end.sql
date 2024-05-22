use schema employees.public;

-- assign project that will end sooner at the hire date
SELECT emp.name as employee, hire_date,
    proj.name as project, start_date, end_date
FROM emp ASOF JOIN proj
    MATCH_CONDITION (hire_date <= end_date)
WHERE hire_date > start_date
ORDER BY hire_date;

CREATE OR REPLACE VIEW proj_fixed AS
    SELECT name, start_date, coalesce(end_date, '2000-01-01') as end_date
    FROM proj;

SELECT emp.name as employee, hire_date,
    proj_fixed.name as project, start_date, end_date
FROM emp ASOF JOIN proj_fixed
    MATCH_CONDITION (hire_date <= end_date)
WHERE hire_date > start_date
ORDER BY hire_date;

