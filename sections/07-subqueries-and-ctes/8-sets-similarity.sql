-- Similarity between Sets
-- https://docs.snowflake.com/en/user-guide/querying-approximate-similarity

SELECT MINHASH(100, $1)
FROM VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (10);

-- Jaccard Index
-- https://en.wikipedia.org/wiki/Jaccard_index
SELECT APPROXIMATE_SIMILARITY($1)
FROM (
    SELECT MINHASH(100, $1)
    FROM VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (10));

with set1 as (
    SELECT *
    FROM VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (10)),
set2 as (
    SELECT * 
    FROM VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (11))
SELECT APPROXIMATE_SIMILARITY($1)
FROM (
    SELECT MINHASH(100, $1) FROM set1
    UNION ALL
    SELECT MINHASH(100, $1) FROM set2
);

with set1 as (SELECT * FROM VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (10)),
set2 as (SELECT * FROM VALUES (1), (2), (3), (4), (5))
SELECT APPROXIMATE_SIMILARITY($1)
FROM (
    SELECT MINHASH(100, $1) FROM set1
    UNION ALL
    SELECT MINHASH(100, $1) FROM set2
);

with set1 as (
    SELECT *
    FROM VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (10)),
set2 as (
    SELECT *
    FROM VALUES (-1), (-2), (-3), (-4), (-5), (-6), (-7), (-8), (-9), (10))
SELECT APPROXIMATE_SIMILARITY($1)
FROM (
    SELECT MINHASH(100, $1) FROM set1
    UNION ALL
    SELECT MINHASH(100, $1) FROM set2
);

with set1 as (
    SELECT *
    FROM VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (10)),
set2 as (
    SELECT *
    FROM VALUES (-1), (-2), (-3), (-4), (-5), (-6), (-7), (-8), (-9), (10))
SELECT MINHASH_COMBINE($1)
FROM (
    SELECT MINHASH(100, $1) FROM set1
    UNION ALL
    SELECT MINHASH(100, $1) FROM set2
);

with set1 as (
    SELECT *
    FROM VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (10)),
set2 as (
    SELECT *
    FROM VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (11)),
set3 as (
    SELECT *
    FROM VALUES (1), (2), (3)),

mh1 as (SELECT MINHASH(100, $1) FROM set1),
mh2 as (SELECT MINHASH(100, $1) FROM set2),
mh3 as (SELECT MINHASH(100, $1) FROM set3)

SELECT APPROXIMATE_SIMILARITY($1)
FROM (
    SELECT MINHASH_COMBINE($1)
    FROM (
        SELECT $1 FROM mh1
        UNION ALL
        SELECT $1 FROM mh2
    )
    UNION ALL
    SELECT $1 FROM mh3
);

-- =============================================================
use test.employees;

with set1 as (
    select name, status, salary
    from emp
    where status <> 'single'),
set2 as (
    select name, status, salary
    from emp
    where salary > 3000)
(select * from set1) union (select * from set2);
-- (select * from set1) intersect (select * from set2);

-- calculated Jaccard index
with set1 as (
    select name, status, salary
    from emp
    where status <> 'single'),
set2 as (
    select name, status, salary
    from emp
    where salary > 3000)
select
    (select count(*)
    from (
        select * from set1
        intersect
        select * from set2)) as i,
    (select count(*)
    from (
        select * from set1
        union
        select * from set2)) as u,
    i / u as Jacard_index;

-- estimated Jaccard index
with set1 as (
    select name, status, salary
    from emp
    where status <> 'single'),
set2 as (
    select name, status, salary
    from emp
    where salary > 3000)
SELECT MINHASH(100, *) mh FROM set1
UNION
SELECT MINHASH(100, *) mh FROM set2;

with set1 as (
    select name, status, salary
    from emp
    where status <> 'single'),
set2 as (
    select name, status, salary
    from emp
    where salary > 3000)
SELECT MINHASH_COMBINE(mh)
FROM (
    SELECT MINHASH(100, *) mh FROM set1
    UNION
    SELECT MINHASH(100, *) mh FROM set2);

with set1 as (
    select name, status, salary
    from emp
    where status <> 'single'),
set2 as (
    select name, status, salary
    from emp
    where salary > 3000)
SELECT APPROXIMATE_JACCARD_INDEX(mh) -- APPROXIMATE_SIMILARITY(mh)
FROM (
   SELECT MINHASH(100, *) mh FROM set1
   UNION
   SELECT MINHASH(100, *) mh FROM set2);

