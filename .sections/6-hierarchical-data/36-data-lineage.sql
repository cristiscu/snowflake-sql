-- show all access history in the account (can get a lot of data!)
select *
from snowflake.account_usage.access_history;

-- paste result to http://magjac.com/graphviz-visual-editor/
select distinct '"' || coalesce(directSources.value:objectName, '.')
    || '" -> "' || coalesce(object_modified.value:objectName, '.') || '"' as link
from snowflake.account_usage.access_history ah,
    lateral flatten(input => objects_modified) object_modified,
    lateral flatten(input => object_modified.value:"columns", outer => true) cols,
    lateral flatten(input => cols.value:directSources, outer => true) directSources;
