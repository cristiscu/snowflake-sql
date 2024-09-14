-- see https://quickstarts.snowflake.com/guide/getting_started_with_streams_and_tasks/index.html
use test.employees;

-- cust_source (table) --> cust_stream (stream) --> cust_target (table)
create or replace table cust_source(id int, name string);
create or replace table cust_target(id int, name string);

create stream cust_stream on table cust_source;

-- task on cust_stream data stream, w/ MERGE statement
create or replace task cust_task
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
  when not matched
    and metadata$action = 'INSERT'
    then insert (id, name) values (s.id, s.name);

-- insert 3 rows in the source table
select system$stream_has_data('cust_stream');
insert into cust_source values (1, 'John'), (2, 'Mary'), (3, 'George');
select system$stream_has_data('cust_stream');

-- could manually execute the task and look at its execution
alter task cust_task resume;
execute task cust_task;
select *
  from table(information_schema.task_history(task_name => 'cust_task'))
  order by run_id desc;

select * from cust_target;

-- update+delete existing source rows --> target should make in-place changes
update cust_source set name = 'Mark' where id = 1;
delete from cust_source where id = 2;
select system$stream_has_data('cust_stream');
select * from cust_target;

-- do not forget to suspend the task when done (or it will consume credits!)
alter task cust_task suspend;
