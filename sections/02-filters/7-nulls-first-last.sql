-- NULLS FIRST/LAST
-- https://docs.snowflake.com/en/sql-reference/constructs/order-by#label-order-by-examples-nulls

-- ===============================================
-- NULLS FIRST

select $1
from (values (3), (1), (null), (null), (2));

select $1
from (values (3), (1), (null), (null), (2))
order by 1;

-- emulated NULLS FIRST
(select $1
from (values (3), (1), (null), (null), (2))
where $1 IS NULL)
UNION ALL
(select $1
from (values (3), (1), (null), (null), (2))
where $1 IS NOT NULL
order by 1);

-- https://docs.snowflake.com/en/sql-reference/data-types-numeric#special-values
select ifnull($1::float, '-inf')
from (values (3), (1), (null), (null), (2))
order by 1;

select $1
from (values (3), (1), (null), (null), (2))
order by 1 NULLS FIRST;

-- ===============================================
-- NULLS LAST

select $1
from (values (3), (1), (null), (null), (2))
order by 1 DESC;

select $1
from (values (3), (1), (null), (null), (2))
order by 1 DESC NULLS LAST;
