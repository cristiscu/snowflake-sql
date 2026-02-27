-- Limiting Returned Data
-- https://docs.snowflake.com/en/sql-reference/constructs/limit

select $1
from values (1), (2), (3), (4), (5);

-- ORDER BY --> deterministic result
select $1
from values (1), (2), (3), (4), (5)
ORDER BY 1;

-- ======================================================
-- TOP
select TOP 2 $1
from (values (1), (2), (3), (4), (5))
order by 1;

select TOP -2 $1
from (values (1), (2), (3), (4), (5))
order by 1;

-- ======================================================
-- LIMIT-OFFSET (PostgreSQL)
select $1
from (values (1), (2), (3), (4), (5))
order by 1
LIMIT 2;

select $1
from (values (1), (2), (3), (4), (5))
order by 1
LIMIT -2;

select $1
from (values (1), (2), (3), (4), (5))
order by 1
LIMIT 2 OFFSET 3;

select $1
from (values (1), (2), (3), (4), (5))
order by 1
OFFSET 3 LIMIT 2;

select $1
from (values (1), (2), (3), (4), (5))
order by 1
OFFSET 3;

select $1
from (values (1), (2), (3), (4), (5))
order by 1
LIMIT null OFFSET null;

select $1
from (values (1), (2), (3), (4), (5))
order by 1
LIMIT '' OFFSET '';

-- ======================================================
-- OFFSET-FETCH (ANSI)
select $1
from (values (1), (2), (3), (4), (5))
order by 1
FETCH 2;

select $1
from (values (1), (2), (3), (4), (5))
order by 1
FETCH 2 OFFSET 3;

select $1
from (values (1), (2), (3), (4), (5))
order by 1
OFFSET 3 FETCH 2;

select $1
from (values (1), (2), (3), (4), (5))
order by 1
FETCH FIRST 2 ROWS ONLY;

select $1
from (values (1), (2), (3), (4), (5))
order by 1
OFFSET 3 ROW FETCH NEXT 2 ROW ONLY;
