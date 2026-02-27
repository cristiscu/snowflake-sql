-- FLATTEN
-- https://docs.snowflake.com/en/sql-reference/functions/flatten 
select *
from snowflake.account_usage.access_history;

-- Data Lineage: show all access history in the account (can get a lot of data!)
-- one-level flatten
select base_objects_accessed boa,
    t.value, t.index
from snowflake.account_usage.access_history ah,
    table(FLATTEN(boa)) t;

select query_id, base_objects_accessed boa,
    t.value, t.index
from snowflake.account_usage.access_history ah,
    table(FLATTEN(boa)) t
where t.value['objectDomain'] = 'Table'
order by query_id;

-- two-levels flatten
select query_id, base_objects_accessed boa,
    t.value, c.value, c.index
from snowflake.account_usage.access_history ah,
    table(FLATTEN(boa)) t,
    table(FLATTEN(t.value['columns'])) c
where t.value['objectDomain'] = 'Table'
order by query_id, t.index, c.index;

select query_id,
    t.value['objectName'] as tname,
    c.value['columnName'] as cname
from snowflake.account_usage.access_history ah,
    table(FLATTEN(base_objects_accessed)) t,
    table(FLATTEN(t.value['columns'])) c
where t.value['objectDomain'] = 'Table'
order by query_id, t.index, c.index;

-- three-levels flatten
-- paste result to http://magjac.com/graphviz-visual-editor/
select distinct '"' || coalesce(directSources.value:objectName, '.')
    || '" -> "' || coalesce(object_modified.value:objectName, '.') || '"' as link
from snowflake.account_usage.access_history ah,
    lateral flatten(input => objects_modified) object_modified,
    lateral flatten(input => object_modified.value:"columns", outer => true) cols,
    lateral flatten(input => cols.value:directSources, outer => true) directSources;
