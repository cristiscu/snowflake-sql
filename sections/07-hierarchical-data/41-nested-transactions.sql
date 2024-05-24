use schema employees.public;

create or replace table log(msg string not null);

-- not scoped transactions: second begin ignored --> show nothing
begin transaction;
insert into log values ('outer');
begin transaction;
insert into log values ('inner');
rollback;
commit;

select * from log;
truncate log;

-- scoped transactions: rolled-back inner --> show only outer
begin transaction;
insert into log values ('outer');
begin
  begin transaction;
  insert into log values ('inner');
  rollback;
end;
commit;

select * from log;
truncate log;

-- scoped transactions: auto-rolled-back inner --> show only outer
begin transaction;
insert into log values ('outer');
begin
  begin transaction;
  insert into log values ('inner');
  -- rollback;
end;
commit;

select * from log;
truncate log;

-- scoped transactions: committed inner --> show only inner
begin transaction;
insert into log values ('outer');
begin
  begin transaction;
  insert into log values ('inner');
  commit;
end;
rollback;

select * from log;
truncate log;

-- different scopes --> not allowed
begin transaction;
insert into log values ('outer');
begin
  insert into log values ('inner');
  rollback; -- fails
end;

select * from log;
truncate log;
