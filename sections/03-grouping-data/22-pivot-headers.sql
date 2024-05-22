use schema employees.public;

create or replace view group_by_job_status as
    select job, status, sum(salary) as salaries
    from emp
    group by job, status;

-- original hard-coded pivot query
select job, "'divorced'", "'married'", "'single'", "NULL"
from group_by_job_status
pivot(max(salaries) for status in ('divorced', 'married', 'single', null));

-- with explicit list of pivot column values from subquery
select *
from group_by_job_status
pivot(max(salaries) for status in (
    select distinct status from group_by_job_status));

-- with implied list of pivot column values
select *
from group_by_job_status
pivot(max(salaries) for status in (ANY));
