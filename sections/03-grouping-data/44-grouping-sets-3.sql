using schema employees.public;

-- GROUPING SETS
select dept_id,
    to_char(year(hire_date)) as year,
    grouping(dept_id) dept_id_g,
    grouping(year) year_g,
    grouping(dept_id, year) dept_id_year_g,
    sum(salary) sals
from emp where year > '1980'
group by grouping sets (dept_id, year)
having sum(salary) > 5000
order by dept_id, year;

-- ROLLUP
select dept_id,
    to_char(year(hire_date)) as year,
    grouping(dept_id) dept_id_g,
    grouping(year) year_g,
    grouping(dept_id, year) dept_id_year_g,
    sum(salary) sals
from emp where year > '1980'
group by rollup (dept_id, year)
having sum(salary) > 5000
order by dept_id, year;

-- CUBE
select dept_id,
    to_char(year(hire_date)) as year,
    grouping(dept_id) dept_id_g,
    grouping(year) year_g,
    grouping(dept_id, year) dept_id_year_g,
    sum(salary) sals
from emp where year > '1980'
group by cube (dept_id, year)
having sum(salary) > 5000
order by dept_id, year;
