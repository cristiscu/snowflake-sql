use test.employees;

select *
from snowflake.account_usage.access_history;

-- one-level flatten
select base_objects_accessed boa,
    t.value, t.index
from snowflake.account_usage.access_history ah,
    table(flatten(boa)) t;

select query_id, base_objects_accessed boa,
    t.value, t.index
from snowflake.account_usage.access_history ah,
    table(flatten(boa)) t
where t.value['objectDomain'] = 'Table'
order by query_id;

-- two-levels flatten
select query_id, base_objects_accessed boa,
    t.value, c.value, c.index
from snowflake.account_usage.access_history ah,
    table(flatten(boa)) t,
    table(flatten(t.value['columns'])) c
where t.value['objectDomain'] = 'Table'
order by query_id, t.index, c.index;

select query_id,
    t.value['objectName'] as tname,
    c.value['columnName'] as cname
from snowflake.account_usage.access_history ah,
    table(flatten(base_objects_accessed)) t,
    table(flatten(t.value['columns'])) c
where t.value['objectDomain'] = 'Table'
order by query_id, t.index, c.index;
