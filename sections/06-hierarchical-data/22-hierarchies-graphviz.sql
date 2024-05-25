use test.employees;

-- variable-depth hierarchy: employee --> manager
create or replace view employee_manager as
    select e.name as employee, m.name as manager 
    from emp e left join emp m on e.mgr_id = m.emp_id;

-- paste result to http://magjac.com/graphviz-visual-editor/
select '"' || manager || '" -> "' || employee || '"' as link
from employee_manager;

/*
digraph {
	graph [rankdir="LR"]
    "Steven King" -> "Neena Kochhar"
    "Steven King" -> "Valli Pataballa"
    "Steven King" -> "Ismael Sciarra"
    "Neena Kochhar" -> "Hermann Baer"
    "Neena Kochhar" -> "Shelley Higgins"
    "Neena Kochhar" -> "Lex De Haan"
    "Neena Kochhar" -> "Alexander Hunold"
    "Neena Kochhar" -> "Bruce Ernst"
    "Valli Pataballa" -> "Nancy Greenberg"
    "Ismael Sciarra" -> "Jose Manuel Urman"
    "Ismael Sciarra" -> "Den Raphaely"
    "Jose Manuel Urman" -> "Luis Popp"
    "Den Raphaely" -> "Alexander Khoo"
}
*/

-- fixed-depth hierarchy: company --> departments --> employees
-- paste result to http://magjac.com/graphviz-visual-editor/
create or replace view department_employees as
    select '(company)' as child, null as parent
    union
    select name, '(company)'
    from dept
    union
    select emp.name, dept.name
    from emp left join dept on emp.dept_id = dept.dept_id;
table department_employees;
select '"' || parent || '" -> "' || child || '"' as hierarchy
from department_employees;

