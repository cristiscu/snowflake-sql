-- Case Sensitive/Insensitive Queries

-- =================================================
-- ORDER BY case sensitivity

-- non-deterministic results: abc, aBc, acd
select $1
from (values ('abc'), ('aBc'), ('acd'));

-- deterministic results, but aBc, abc, acd (alphabetical ASCII)
select $1
from (values ('abc'), ('aBc'), ('acd'))
order by 1;

-- deterministic results: abc, aBc, acd
select $1
from (values ('abc'), ('aBc'), ('acd'))
order by lower($1);

-- deterministic results: abc, aBc, acd
-- https://docs.snowflake.com/en/sql-reference/functions/collate
select *
from (values ('abc'), ('aBc'), ('acd'))
order by COLLATE($1, 'en');

-- =================================================
-- GROUP BY case sensitivity

select DISTINCT *
from (values ('abc'), ('aBc'), ('acd'));

select DISTINCT lower($1)
from (values ('abc'), ('aBc'), ('acd'));

select *
from (values ('abc'), ('aBc'), ('acd'))
GROUP BY 1;

-- =================================================
-- WHERE case sensitivity

select *
from (values ('abc'), ('aBc'), ('acd'))
where $1 = 'aBc';

select *
from (values ('abc'), ('aBc'), ('acd'))
where $1 = 'abc';

select *
from (values ('abc'), ('aBc'), ('acd'))
where lower($1) = lower('abc');

-- try also NOT LIKE, ILIKE, NOT ILIKE, w/ a_c
select *
from (values ('abc'), ('aBc'), ('acd'))
where $1 LIKE 'abc';

-- [NOT] ILIKE/LIKE ALL/ANY [SELECT]
select *
from (values ('abc'), ('aBc'), ('acd'))
where $1 LIKE ALL ('a_c', 'a%c', '%_c');

select *
from (values ('abc'), ('aBc'), ('acd'))
where $1 LIKE ALL (SELECT 'a_c', 'a%c', '%_c');
