set s = 'It is cold and the OLD MAN wants to sleep, before the soldiers arrive.';

select $s LIKE '\\%\\_old\\%' ESCAPE '\\',
    $s LIKE '%_old%',
    $s LIKE '%_oLD%',
    $s ILIKE '%_oLD%',
    $s RLIKE '^.*OLD.*$';

select REGEXP_COUNT($s, '(.old)', 10);
select REGEXP_COUNT($s, '(.old)', 1, 'i');

select REGEXP_INSTR($s, '(.old)');
select REGEXP_EXTRACT_ALL($s, '(.old)', 1, 1, 'i');

select REGEXP_REPLACE($s, '(.old)', '12345678');
