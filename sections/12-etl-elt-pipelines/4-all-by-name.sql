-- alternative to MERGE, w/ INSERT/UPDATE ALL BY NAME
-- https://docs.snowflake.com/en/sql-reference/sql/merge#perform-a-merge-by-using-all-by-name
use test.employees;

-- uncomment the ALL BY NAME lines and comment out the original UPDATE/INSERT lines
create or replace task cust_task2
  warehouse = compute_wh
  schedule = '1 minute'
  when system$stream_has_data('cust_stream')
as
  merge into cust_target t using cust_stream s on t.id = s.id
  when matched
    and metadata$action = 'DELETE'
    and metadata$isupdate = 'FALSE'
    then delete
  when matched
    and metadata$action = 'INSERT'
    and metadata$isupdate = 'TRUE'
    then update set t.name = s.name
    -- then update ALL BY NAME
  when not matched
    and metadata$action = 'INSERT'
    then insert (id, name) values (s.id, s.name);
    -- then insert ALL BY NAME;
