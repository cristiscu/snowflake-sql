-- show all obj deps in account (can get a lot of data!)
select * 
from snowflake.account_usage.object_dependencies;

-- paste result to http://magjac.com/graphviz-visual-editor/
select '"' || referencing_database
    || '.' || referencing_schema
    || '.' || referencing_object_name
    || '" -> "'
    || referenced_database
    || '.' || referenced_schema
    || '.' || referenced_object_name
    || '"' as link
from snowflake.account_usage.object_dependencies;

