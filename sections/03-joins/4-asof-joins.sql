-- ASOF Joins: assign most recently started project compared to the hire date
-- see https://docs.snowflake.com/en/sql-reference/constructs/asof-join

with emp(employee, hire_date) as (
    select $1, $2::timestamp_ntz from values
    ('Steven King',       '1981-11-17'),
    ('Neena Kochhar',     '1981-05-01'),
    ('Hermann Baer',      '1981-09-28'),
    ('Shelley Higgins',   '1981-02-20'),
    ('Lex De Haan',       '1981-02-22'),
    ('Alexander Hunold',  '1981-12-03'),
    ('Bruce Ernst',       '1981-09-08'),
    ('Valli Pataballa',   '1981-06-09'),
    ('Nancy Greenberg',   '1982-01-23'),
    ('Ismael Sciarra',    '1981-04-02'),
    ('Jose Manuel Urman', '1982-12-09'),
    ('Luis Popp',         '1983-01-12'),
    ('Den Raphaely',      '1981-12-03'),
    ('Alexander Khoo',    '1980-12-17')),

proj(project, start_date, end_date) as (
    select $1, $2::timestamp_ntz, $3::timestamp_ntz from values
    ('Cleanup Data',          '1980-12-05',   '1981-01-09'),
    ('ETL Pipeline',          '1981-01-09',   '1981-04-02'),
    ('Data Preprocessing',    '1981-04-02',   '1981-06-08'),
    ('Create Dashboard',      '1981-06-09',   '1981-07-22'),
    ('ML Kickoff',            '1981-08-28',   '1981-09-11'),
    ('Model Training',        '1981-09-28',   '1982-12-10'),
    ('Model Deployment',      '1982-12-11',   null        ))

SELECT employee, project, hire_date, start_date, end_date
FROM emp LEFT JOIN proj ON hire_date = start_date
-- FROM emp ASOF JOIN proj MATCH_CONDITION (hire_date >= start_date)
WHERE end_date is null or hire_date < end_date
ORDER BY hire_date;

-- ==============================================================
-- see https://duckdb.org/2023/09/15/asof-joins-fuzzy-temporal-lookups.html
with emp(employee, hire_date) as (
    select $1, $2::timestamp_ntz from values
    ('Steven King',       '1981-11-17'),
    ('Neena Kochhar',     '1981-05-01'),
    ('Hermann Baer',      '1981-09-28'),
    ('Shelley Higgins',   '1981-02-20'),
    ('Lex De Haan',       '1981-02-22'),
    ('Alexander Hunold',  '1981-12-03'),
    ('Bruce Ernst',       '1981-09-08'),
    ('Valli Pataballa',   '1981-06-09'),
    ('Nancy Greenberg',   '1982-01-23'),
    ('Ismael Sciarra',    '1981-04-02'),
    ('Jose Manuel Urman', '1982-12-09'),
    ('Luis Popp',         '1983-01-12'),
    ('Den Raphaely',      '1981-12-03'),
    ('Alexander Khoo',    '1980-12-17')),

proj(project, start_date, end_date) as (
    select $1, $2::timestamp_ntz, $3::timestamp_ntz from values
    ('Cleanup Data',          '1980-12-05',   '1981-01-09'),
    ('ETL Pipeline',          '1981-01-09',   '1981-04-02'),
    ('Data Preprocessing',    '1981-04-02',   '1981-06-08'),
    ('Create Dashboard',      '1981-06-09',   '1981-07-22'),
    ('ML Kickoff',            '1981-08-28',   '1981-09-11'),
    ('Model Training',        '1981-09-28',   '1982-12-10'),
    ('Model Deployment',      '1982-12-11',   null        )),

proj_cte AS (
    SELECT project, start_date, end_date,
        LEAD(start_date, 1) OVER (ORDER BY start_date) AS next_start_date
    FROM proj)

SELECT employee, project, hire_date, start_date, end_date
FROM emp LEFT JOIN proj_cte
    ON (end_date is null or hire_date < end_date)
    AND hire_date >= start_date
    AND (next_start_date is null or hire_date < next_start_date)
ORDER BY hire_date;
