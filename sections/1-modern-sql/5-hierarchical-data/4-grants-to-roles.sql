-- see https://medium.com/snowflake/the-snowflake-role-hierarchy-with-recursive-queries-c3210ac4f620

create or replace role bmo_sysadmin_role;
create or replace role bmo_devuser_role;
create or replace role bmo_elt_role;
create or replace role bmo_readwrite_role;
create or replace role bmo_readonly_role;

grant role bmo_readonly_role to role bmo_readwrite_role;
grant role bmo_readwrite_role to role bmo_devuser_role;
grant role bmo_readwrite_role to role bmo_elt_role;
grant role bmo_devuser_role to role bmo_sysadmin_role;
grant role bmo_elt_role to role bmo_sysadmin_role;

-- ==================================================================
select *
from snowflake.account_usage.grants_to_roles;

select *
from snowflake.account_usage.grants_to_roles
where granted_on = 'ROLE'
    and granted_to = 'ROLE'
    and privilege = 'USAGE'
    and deleted_on is null;

-- paste result to http://magjac.com/graphviz-visual-editor/
select grantee_name || ' -> ' || name as link
from snowflake.account_usage.grants_to_roles
where granted_on = 'ROLE'
    and granted_to = 'ROLE'
    and privilege = 'USAGE'
    and deleted_on is null
    and grantee_name like 'BMO_%'
order by name;

-- all inherited roles
with recursive cte as (
    select grantee_name, name
    from snowflake.account_usage.grants_to_roles
    where granted_on = 'ROLE'
        and granted_to = 'ROLE'
        and privilege = 'USAGE'
        and deleted_on is null
        --and grantee_name = 'BMO_SYSADMIN_ROLE'
    union all
    select g.grantee_name, g.name
    from snowflake.account_usage.grants_to_roles g
        join cte r on g.grantee_name = r.name
    where g.granted_on = 'ROLE'
        and g.granted_to = 'ROLE'
        and g.privilege = 'USAGE'
        and g.deleted_on is null)
select distinct name
    from cte
    order by name;

-- all objects with their owner roles
with roles_rec as (
    select grantee_name, name
    from snowflake.account_usage.grants_to_roles
    where granted_on = 'ROLE'
        and granted_to = 'ROLE'
        and privilege = 'USAGE'
        and deleted_on is null),
roles as (
    select distinct name
    from roles_rec
    start with grantee_name = 'BMO_SYSADMIN_ROLE'
    connect by grantee_name = prior name
    order by name)
select grantee_name, granted_on,
    case when granted_on = 'DATABASE' then table_catalog
    when granted_on = 'SCHEMA' then
        table_catalog || '.' || table_schema
    when table_catalog is not null then
        table_catalog || '.' || table_schema || '.' || name
    else name end as object_name
from snowflake.account_usage.grants_to_roles
where granted_on <> 'ROLE'
    and privilege = 'OWNERSHIP'
    and deleted_on is null
    and (grantee_name = 'BMO_SYSADMIN_ROLE' or grantee_name in (select * from roles))
order by grantee_name;

