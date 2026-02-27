-- Sessions and SQL Worksheets/Files
-- https://cristian-70480.medium.com/all-about-the-snowflake-identifiers-and-variables-64d0cf3181be
-- https://docs.snowflake.com/en/user-guide/ui-snowsight-worksheets-gs
use test.employees;

-- current context functions
select current_role(), current_warehouse(), current_database(), current_schema();

select current_date(), current_time(), current_timestamp();

select current_user(), is_role_in_session('accountadmin');
select current_available_roles();

-- query result cache
select last_query_id();
select *
from table(result_scan(last_query_id(-2)));

-- temp objects
create temporary table this_will_go_away(s string);
-- drop table this_will_go_away;

-- session vars
set s = 'this is a string';
select $s;

-- session params
show parameters in session;
alter session set query_tag = 'session-demo';
show parameters like 'query_tag' in session;

select top 10 *
from table(information_schema.query_history());