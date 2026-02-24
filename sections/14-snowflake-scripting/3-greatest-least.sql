use test.employees;

select max(salary), max(commission),
    min(salary), min(commission)
from emp;

select salary x, commission y,
    greatest(x, y) as g
from emp;

-- emulated
select salary x, commission y,
    case when x > y then x else y end g1,
    iff(x > y, x, y) g2
from emp;

-- GREATEST(x, y) = ((x + y) + ABS(x - y)) / 2
select salary x, commission y,
    greatest(x, y) g,
    ((x + y) + abs(x - y)) / 2 as g2
from emp;

-- LEAST(x, y) = ((x + y) - ABS(x - y)) / 2
select salary x, commission y,
    least(x, y) as l,
    ((x + y) - abs(x - y)) / 2 as l2
from emp;

select GREATEST(2, 5, 12, 3) g1,
    GREATEST('2', '5', '12', '3') g2,
    GREATEST('apples', 'oranges', 'bananas') g3,
    GREATEST('apples', 'applis', 'applas') g4,
    GREATEST('apples', 'applis', 'applas', null) g5;

select LEAST(2, 5, 12, 3) l1,
    LEAST('2', '5', '12', '3') l2,
    LEAST('apples', 'oranges', 'bananas') l3,
    LEAST('apples', 'applis', 'applas') l4,
    LEAST('apples', 'applis', 'applas', null) l5;

select GREATEST(2, 5, NULL, 12, 3) g1,
    GREATEST_IGNORE_NULLS(2, 5, NULL, 12, 3) g2;
