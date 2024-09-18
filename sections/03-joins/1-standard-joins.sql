-- see https://docs.snowflake.com/en/sql-reference/constructs/join

/*
country --> city - 1-N relationship
-----------------------------------
Canada: Vancouver, Toronto
Romania: Bucharest
France and Iran: no child cities
New York: no parent country
*/
select * from values (1, 'Canada'), (2, 'Romania'), (3, 'France'), (4, 'Iran') as nations(nid, nation);
select * from values (1, 'Vancouver'), (2, 'Bucharest'), (1, 'Toronto'), (null, 'New York') as cities(cid, city);

-- ===========================================================
-- CROSS JOIN (cartesian product of all non-NULL rows from both sides)
with nations(nid, nation) as (
    select * from values (1, 'Canada'), (2, 'Romania'), (3, 'France'), (4, 'Iran')),
cities(cid, city) as (
    select * from values (1, 'Vancouver'), (2, 'Bucharest'), (1, 'Toronto'), (null, 'New York'))
select nation, city
from nations CROSS JOIN cities;

with nations(nid, nation) as (
    select * from values (1, 'Canada'), (2, 'Romania'), (3, 'France'), (4, 'Iran')),
cities(cid, city) as (
    select * from values (1, 'Vancouver'), (2, 'Bucharest'), (1, 'Toronto'), (null, 'New York'))
select nation, city
from nations, cities;

with nations(nid, nation) as (
    select * from values (1, 'Canada'), (2, 'Romania'), (3, 'France'), (4, 'Iran')),
cities(cid, city) as (
    select * from values (1, 'Vancouver'), (2, 'Bucharest'), (1, 'Toronto'), (null, 'New York'))
select nation, city
from nations INNER JOIN cities;

-- ===========================================================
-- INNER JOIN (all rows from both sides in common)
with nations(nid, nation) as (
    select * from values (1, 'Canada'), (2, 'Romania'), (3, 'France'), (4, 'Iran')),
cities(cid, city) as (
    select * from values (1, 'Vancouver'), (2, 'Bucharest'), (1, 'Toronto'), (null, 'New York'))
select nation, city
from nations INNER JOIN cities ON nid = cid;

with nations(nid, nation) as (
    select * from values (1, 'Canada'), (2, 'Romania'), (3, 'France'), (4, 'Iran')),
cities(cid, city) as (
    select * from values (1, 'Vancouver'), (2, 'Bucharest'), (1, 'Toronto'), (null, 'New York'))
select nation, city
from nations JOIN cities ON nid = cid;

with nations(nid, nation) as (
    select * from values (1, 'Canada'), (2, 'Romania'), (3, 'France'), (4, 'Iran')),
cities(cid, city) as (
    select * from values (1, 'Vancouver'), (2, 'Bucharest'), (1, 'Toronto'), (null, 'New York'))
select nation, city
from nations, cities
where nid = cid;

-- NATURAL JOIN (on nid) --> INNER JOIN
with nations(nid, nation) as (
    select * from values (1, 'Canada'), (2, 'Romania'), (3, 'France'), (4, 'Iran')),
cities(nid, city) as (
    select * from values (1, 'Vancouver'), (2, 'Bucharest'), (1, 'Toronto'), (null, 'New York'))
select nation, city
from nations NATURAL JOIN cities;

with nations(nid, nation) as (
    select * from values (1, 'Canada'), (2, 'Romania'), (3, 'France'), (4, 'Iran')),
cities(nid, city) as (
    select * from values (1, 'Vancouver'), (2, 'Bucharest'), (1, 'Toronto'), (null, 'New York'))
select nation, city
from nations JOIN cities USING (nid);

-- ===========================================================
-- LEFT JOIN (all countries, regardless of cities)
with nations(nid, nation) as (
    select * from values (1, 'Canada'), (2, 'Romania'), (3, 'France'), (4, 'Iran')),
cities(cid, city) as (
    select * from values (1, 'Vancouver'), (2, 'Bucharest'), (1, 'Toronto'), (null, 'New York'))
select nation, city
from nations LEFT OUTER JOIN cities ON nid = cid;

-- *= for SQL-Server, += for Oracle (not supported)
with nations(nid, nation) as (
    select * from values (1, 'Canada'), (2, 'Romania'), (3, 'France'), (4, 'Iran')),
cities(cid, city) as (
    select * from values (1, 'Vancouver'), (2, 'Bucharest'), (1, 'Toronto'), (null, 'New York'))
select nation, city
from nations, cities
where nid += cid;

-- (bad)
with nations(nid, nation) as (
    select * from values (1, 'Canada'), (2, 'Romania'), (3, 'France'), (4, 'Iran')),
cities(cid, city) as (
    select * from values (1, 'Vancouver'), (2, 'Bucharest'), (1, 'Toronto'), (null, 'New York'))
select nation, city
from nations, cities
where nid = cid OR nid not in (select cid from cities where cid is not null);

-- (emulated)
with nations(nid, nation) as (
    select * from values (1, 'Canada'), (2, 'Romania'), (3, 'France'), (4, 'Iran')),
cities(cid, city) as (
    select * from values (1, 'Vancouver'), (2, 'Bucharest'), (1, 'Toronto'), (null, 'New York'))
select nation, city
from nations INNER JOIN cities ON nid = cid
union
select nation, null
from nations
where nid not in (select cid from cities where cid is not null);

-- NATURAL LEFT JOIN (on nid) --> LEFT JOIN
with nations(nid, nation) as (
    select * from values (1, 'Canada'), (2, 'Romania'), (3, 'France'), (4, 'Iran')),
cities(nid, city) as (
    select * from values (1, 'Vancouver'), (2, 'Bucharest'), (1, 'Toronto'), (null, 'New York'))
select nation, city
from nations NATURAL LEFT JOIN cities;

with nations(nid, nation) as (
    select * from values (1, 'Canada'), (2, 'Romania'), (3, 'France'), (4, 'Iran')),
cities(nid, city) as (
    select * from values (1, 'Vancouver'), (2, 'Bucharest'), (1, 'Toronto'), (null, 'New York'))
select nation, city
from nations LEFT JOIN cities USING (nid);

-- EXCLUDE LEFT JOIN (countries w/ no cities)
with nations(nid, nation) as (
    select * from values (1, 'Canada'), (2, 'Romania'), (3, 'France'), (4, 'Iran')),
cities(cid, city) as (
    select * from values (1, 'Vancouver'), (2, 'Bucharest'), (1, 'Toronto'), (null, 'New York'))
select nation, city
from nations LEFT OUTER JOIN cities ON nid = cid
where cid is null;

-- (emulated)
with nations(nid, nation) as (
    select * from values (1, 'Canada'), (2, 'Romania'), (3, 'France'), (4, 'Iran')),
cities(cid, city) as (
    select * from values (1, 'Vancouver'), (2, 'Bucharest'), (1, 'Toronto'), (null, 'New York'))
select nation
from nations
where not exists (select * from cities where nid = cid);

-- ===========================================================
-- RIGHT JOIN (all cities, regardless of country)
with nations(nid, nation) as (
    select * from values (1, 'Canada'), (2, 'Romania'), (3, 'France'), (4, 'Iran')),
cities(cid, city) as (
    select * from values (1, 'Vancouver'), (2, 'Bucharest'), (1, 'Toronto'), (null, 'New York'))
select nation, city
from nations RIGHT OUTER JOIN cities ON nid = cid;

-- (bad)
with nations(nid, nation) as (
    select * from values (1, 'Canada'), (2, 'Romania'), (3, 'France'), (4, 'Iran')),
cities(cid, city) as (
    select * from values (1, 'Vancouver'), (2, 'Bucharest'), (1, 'Toronto'), (null, 'New York'))
select nation, city
from nations, cities
where nid = cid OR cid is null;

-- (emulated)
with nations(nid, nation) as (
    select * from values (1, 'Canada'), (2, 'Romania'), (3, 'France'), (4, 'Iran')),
cities(cid, city) as (
    select * from values (1, 'Vancouver'), (2, 'Bucharest'), (1, 'Toronto'), (null, 'New York'))
select nation, city
from nations INNER JOIN cities ON nid = cid
union
select null, city
from cities
where cid is null;

-- NATURAL RIGHT JOIN (on nid) --> RIGHT JOIN
with nations(nid, nation) as (
    select * from values (1, 'Canada'), (2, 'Romania'), (3, 'France'), (4, 'Iran')),
cities(nid, city) as (
    select * from values (1, 'Vancouver'), (2, 'Bucharest'), (1, 'Toronto'), (null, 'New York'))
select nation, city
from nations NATURAL RIGHT JOIN cities;

-- EXCLUDE RIGHT JOIN (cities w/ no country)
with nations(nid, nation) as (
    select * from values (1, 'Canada'), (2, 'Romania'), (3, 'France'), (4, 'Iran')),
cities(cid, city) as (
    select * from values (1, 'Vancouver'), (2, 'Bucharest'), (1, 'Toronto'), (null, 'New York'))
select nation, city
from nations RIGHT OUTER JOIN cities ON nid = cid
where nid is null;

-- (emulated)
with nations(nid, nation) as (
    select * from values (1, 'Canada'), (2, 'Romania'), (3, 'France'), (4, 'Iran')),
cities(cid, city) as (
    select * from values (1, 'Vancouver'), (2, 'Bucharest'), (1, 'Toronto'), (null, 'New York'))
select city
from cities
where cid is null;

-- ===========================================================
-- FULL JOIN (all rows from both sides)
with nations(nid, nation) as (
    select * from values (1, 'Canada'), (2, 'Romania'), (3, 'France'), (4, 'Iran')),
cities(cid, city) as (
    select * from values (1, 'Vancouver'), (2, 'Bucharest'), (1, 'Toronto'), (null, 'New York'))
select nation, city
from nations FULL OUTER JOIN cities ON nid = cid;

-- EXCLUDE JOIN (all rows from both sides, except those in common)
with nations(nid, nation) as (
    select * from values (1, 'Canada'), (2, 'Romania'), (3, 'France'), (4, 'Iran')),
cities(cid, city) as (
    select * from values (1, 'Vancouver'), (2, 'Bucharest'), (1, 'Toronto'), (null, 'New York'))
select nation, city
from nations FULL OUTER JOIN cities ON nid = cid
where nid is null or cid is null;
