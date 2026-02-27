-- String Tokens

select parse_ip('26.11.98.128', 'cidr'),
    parse_url('https://docs.snowflake.com/en/sql-reference');

set s = $$
I am a new customer for less than a year and I have never
had to visit a branch this much in my lifetime.
I've had my banking card locked THREE times for fraud.
$$;

select length($s);
select split($s, '.');

select split($s, '\r\n'), strtok_to_array($s, '\r\n');
select split_part($s, '\r\n', 2), strtok($s, '\r\n', 1);

select t.value
from table(split_to_table($s, '\r\n')) t;
select t.value
from table(strtok_split_to_table($s, '\r\n')) t;

select listagg(t.value, '\r\n\r\n')
from table(strtok_split_to_table($s, '\r\n')) t;

select hash(t.value)
from table(strtok_split_to_table($s, '\r\n')) t;
select hash_agg(t.value)
from table(strtok_split_to_table($s, '\r\n')) t;
