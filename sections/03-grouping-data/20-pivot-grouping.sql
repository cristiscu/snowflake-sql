use schema test.employees;

-- w/o distinct job titles
select job, "'divorced'", "'married'", "'single'"
from emp
pivot(sum(salary) for status in ('divorced', 'married', 'single'))
order by job;

-- w/ distinct job titles
select job, "'divorced'", "'married'", "'single'"
from (select job, status, salary from emp)
pivot(sum(salary) for status in ('divorced', 'married', 'single'))
order by job;

-- w/ distinct job titles (alternative w/ inner GROUP BY)
select job, "'divorced'", "'married'", "'single'"
from (select job, status, sum(salary) as salaries from emp group by job, status)
pivot(max(salaries) for status in ('divorced', 'married', 'single'))
order by job;

-- w/ multiple GROUP BY
select job, education, "'divorced'", "'married'", "'single'"
from (select job, education, status, salary from emp)
pivot(sum(salary) for status in ('divorced', 'married', 'single'))
order by job, education;
