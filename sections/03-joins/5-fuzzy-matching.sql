-- see https://das42.com/thought-leadership/fuzzy-matching-in-snowflake/
use snowflake_sample_data.tpch_sf1;

select distinct n_name
from nation;

/*
ROMANIA
BRAZIL
FRANCE
SAUDI ARABIA
UNITED STATES
RUSSIA
...
*/

with employees(name, country) as (
    select *
    from values ('Ion', 'România'),
        ('Miguel', ' Brazilia'),
        ('Michelle', 'Franța '),
        ('Ahmet', 'Arabia Saudită'),
        ('John', 'Statele  Unite'),
        ('Evgeni', 'Rusia'),
        ('Laura', 'Elveția'))
select name, country, n_name,
    editdistance(lower(country), lower(n_name)) ed,
    jarowinkler_similarity(lower(country), lower(n_name)) jws,
    soundex(country) sc, soundex(n_name) sn,
    soundex_p123(country) sc123, soundex_p123(n_name) sn123
from employees left join nation
-- on ed < 3;
-- on jws > 80
-- on sc = sn;
on sc123 = sn123;

with employees(name, country) as (
    select *
    from values ('Ion', 'România'),
        ('Miguel', ' Brazilia'),
        ('Michelle', 'Franța '),
        ('Ahmet', 'Arabia Saudită'),
        ('John', 'Statele  Unite'),
        ('Evgeni', 'Rusia'),
        ('Laura', 'Elveția')),
employees2 as (
    select name, country,
        regexp_replace(lower(trim(country)), '[^a-z0-9]', '') country2
    from employees),
nation2 as (
    select n_name,
        regexp_replace(lower(trim(n_name)), '[^a-z0-9]', '') n_name2
    from nation)
select name, country, n_name,
    editdistance(country2, n_name2) ed,
    jarowinkler_similarity(country2, n_name2) jws,
    soundex(country2) sc, soundex(n_name2) sn,
    soundex_p123(country2) sc123, soundex_p123(n_name2) sn123
from employees2 left join nation2
-- on ed < 3;
on jws > 80
-- on sc = sn;
-- on sc123 = sn123;