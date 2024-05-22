use schema employees.public;

-- emulated UNPIVOT
SELECT job, 'divorced' as status, "'divorced'" as salaries,
FROM pivot_by_job_status
UNION ALL
SELECT job, 'married', "'married'"
FROM pivot_by_job_status
UNION ALL
SELECT job, 'single', "'single'"
FROM pivot_by_job_status
UNION ALL
SELECT job, null, "NULL"
FROM pivot_by_job_status;