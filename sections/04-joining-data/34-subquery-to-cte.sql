use schema employees.public;

-- subqueries
select ee.dept_id,
  sum(ee.salary) as sum_sal,
  (select max(salary)
   from emp
   where dept_id = ee.dept_id) as max_sal
from emp ee
where ee.emp_id in
  (select emp_id
   from emp e
   join dept d on e.dept_id = d.dept_id
   where d.name <> 'RESEARCH')
group by ee.dept_id
order by ee.dept_id;

-- equivalent CTEs
with q1 as 
  (select emp_id
   from emp e
   join dept d on e.dept_id = d.dept_id
   where d.name <> 'RESEARCH'),

q2 as 
  (select dept_id, max(salary) max_sal
   from emp
   group by dept_id)

select ee.dept_id,
  sum(ee.salary) as sum_sal,
  max(q2.max_sal) as max_sal
from emp ee
  join q2 on q2.dept_id = ee.dept_id
  join q1 on q1.emp_id = ee.emp_id
group by ee.dept_id
order by ee.dept_id;
