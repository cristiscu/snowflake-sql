-- Duplicate and Distinct Values
-- https://stackoverflow.com/questions/68747548/selecting-duplicate-rows-with-distinct-column-values
use test.employees;

-- duplicate rows
select distinct e1.name, e1.job
from emp e1
    left join emp e2
    on e1.job = e2.job and e1.name <> e2.name
where e2.name is not null;

-- unicate rows
select distinct e1.name, e1.job
from emp e1
    left join emp e2
    on e1.job = e2.job and e1.name <> e2.name
where e2.name is null;
