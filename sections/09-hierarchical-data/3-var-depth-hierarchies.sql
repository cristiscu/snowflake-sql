-- Variable-Depth Hierarchies
use test.employees;

-- employee --> manager
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
