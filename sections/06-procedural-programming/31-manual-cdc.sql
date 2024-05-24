use schema test.employees;

-- source (table) --> target (table), w/ MERGE in stored proc
CREATE OR REPLACE TABLE cust_source(del BOOLEAN, id INT, name STRING);
CREATE OR REPLACE TABLE cust_target(id INT, name STRING);

merge into cust_target t using cust_source s on t.id = s.id
    when not matched and not del
        then insert (id, name) values (s.id, s.name)
    when matched and del
        then delete
    when matched and not del
        then update set t.name = s.name;

create or replace procedure cust_cdc() returns int
as $$
    merge into cust_target t using cust_source s on t.id = s.id
        when not matched and not del
            then insert (id, name) values (s.id, s.name)
        when matched and del
            then delete
        when matched and not del
            then update set t.name = s.name
$$;

-- 3 x INSERT
INSERT INTO cust_source
    VALUES (False, 1, 'John'), (False, 2, 'Mary'), (False, 3, 'George');
CALL cust_cdc();
TRUNCATE TABLE cust_source;
SELECT * FROM cust_target;

-- UPDATE + INSERT
INSERT INTO cust_source
    VALUES (False, 1, 'Mark'), (True, 2, NULL);
CALL cust_cdc();
TRUNCATE TABLE cust_source;
SELECT * FROM cust_target;
