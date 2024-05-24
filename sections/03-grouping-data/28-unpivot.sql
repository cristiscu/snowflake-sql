use schema test.employees;

create or replace view pivot_by_job_status as
    select *
    from group_by_job_status
    pivot(max(salaries) for status in (ANY));

table pivot_by_job_status;

SELECT job, TRIM(status, '''') as status, salaries
FROM pivot_by_job_status
UNPIVOT (salaries FOR status IN ("'divorced'", "'married'", "'single'", "NULL"));

/*
SELECT job, TRIM(status, '''') as status, salaries
FROM pivot_by_job_status
UNPIVOT (salaries FOR status IN (LISTAGG(SELECT status FROM emp GROUP BY status)));
*/