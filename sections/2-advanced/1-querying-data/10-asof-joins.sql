use test.employees;

-- assign most recently started project compared to the hire date
-- with exact match left join
SELECT emp.name as employee, hire_date,
    proj.name as project, start_date, end_date
FROM emp LEFT JOIN proj ON hire_date = start_date
WHERE end_date is null or hire_date < end_date
ORDER BY hire_date;

-- with AsOf join
SELECT emp.name as employee, hire_date,
    proj.name as project, start_date, end_date
FROM emp ASOF JOIN proj
    MATCH_CONDITION (hire_date >= start_date)
WHERE end_date is null or hire_date < end_date
ORDER BY hire_date;

-- see https://duckdb.org/2023/09/15/asof-joins-fuzzy-temporal-lookups.html
WITH proj_cte AS (
  SELECT name, start_date, end_date,
    LEAD(start_date, 1) OVER (ORDER BY start_date) AS next_start_date
  FROM proj)
SELECT emp.name as employee, hire_date,
    proj_cte.name as project, start_date, end_date
FROM emp LEFT JOIN proj_cte
    ON (end_date is null or hire_date < end_date)
    AND hire_date >= start_date
    AND (next_start_date is null or hire_date < next_start_date)
ORDER BY hire_date;

-- ===============================================================
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


