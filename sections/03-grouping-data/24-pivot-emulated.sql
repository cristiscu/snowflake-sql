use schema employees.public;

-- emulated
select job,
    sum(case status when 'divorced' then salary end) as "'divorced'",
    sum(case status when 'married' then salary end) as "'married'",
    sum(case status when 'single' then salary end) as "'single'"
from emp
group by job;

-- emulated + with 2 pivoted columns
select job,
    sum(case when status='divorced' and gender='F'
        then salary end) as "'divorced+F'",
    sum(case when status='divorced' and gender='M'
        then salary end) as "'divorced+M'",
    sum(case when status='married' and gender='F'
        then salary end) as "'married+F'",
    sum(case when status='married' and gender='M'
        then salary end) as "'married+M'",
    sum(case when status='single' and gender='F'
        then salary end) as "'single+F'",
    sum(case when status='single' and gender='M'
        then salary end) as "'single+M'"
from emp
group by job;

-- count people
select job,
    count(case status when 'divorced' then 1 end) as "'divorced'",
    count(case status when 'married' then 1 end) as "'married'",
    count(case status when 'single' then 1 end) as "'single'"
from emp
group by job;

select job,
    count_if(status = 'divorced') as "'divorced'",
    count_if(status = 'married') as "'married'",
    count_if(status = 'single') as "'single'"
from emp
group by job;
