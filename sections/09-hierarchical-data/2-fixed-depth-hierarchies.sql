-- Fixed-Depth Hierarchies
use test.employees;

-- company --> departments --> employees
create or replace view department_employees as
    select '(company)' as child, null as parent
    union
    select name, '(company)'
    from dept
    union
    select emp.name, dept.name
    from emp left join dept on emp.dept_id = dept.dept_id;
table department_employees;

-- paste result to http://magjac.com/graphviz-visual-editor/
select '"' || parent || '" -> "' || child || '"' as hierarchy
from department_employees;
