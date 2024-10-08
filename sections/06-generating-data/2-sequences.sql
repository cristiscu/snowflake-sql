-- see https://docs.snowflake.com/en/user-guide/querying-sequences
-- see https://community.snowflake.com/s/article/Why-does-a-gap-occur-on-identity-columns
use test.employees;

-- =========================================================
-- Sequences
CREATE OR REPLACE SEQUENCE seq1
    START = 1
    INCREMENT = 1
    ORDER;
ALTER SEQUENCE seq1 SET INCREMENT = -5;
ALTER SEQUENCE seq1 SET NOORDER;
SELECT seq1.NEXTVAL,
    seq1.NEXTVAL,
    seq1.NEXTVAL,
    seq1.NEXTVAL,
    seq1.NEXTVAL;
SELECT seq1.NEXTVAL
FROM table(generator(rowcount => 5));

-- =========================================================
-- populate value from sequence
create or replace sequence seq2;
create or replace transient table proj2 (
	proj_id     integer     DEFAULT seq2.nextval    PRIMARY KEY,
	name        string      NOT NULL                UNIQUE,
	start_date  date        NOT NULL,
    end_date    date);

insert into proj2(name, start_date, end_date)
values
    ('Cleanup Data',          '1980-12-05',   '1981-01-09'    ),
    ('ETL Pipeline',          '1981-01-09',   '1981-04-02'    ),
    ('Data Preprocessing',    '1981-04-02',   '1981-06-08'    ),
    ('Create Dashboard',      '1981-06-09',   '1981-07-22'    ),
    ('ML Kickoff',            '1981-08-28',   '1981-09-11'    ),
    ('Model Training',        '1981-09-28',   '1982-12-10'    ),
    ('Model Deployment',      '1982-12-11',   null            );
table proj2;

-- =========================================================
-- populate value from autoincrement
create or replace temporary table proj3 (
	proj_id     integer     IDENTITY(1, 1) ORDER    PRIMARY KEY,
	name        string      NOT NULL                UNIQUE,
	start_date  date        NOT NULL,
    end_date    date);

insert into proj3(name, start_date, end_date)
values
    ('Cleanup Data',          '1980-12-05',   '1981-01-09'    ),
    ('ETL Pipeline',          '1981-01-09',   '1981-04-02'    ),
    ('Data Preprocessing',    '1981-04-02',   '1981-06-08'    ),
    ('Create Dashboard',      '1981-06-09',   '1981-07-22'    ),
    ('ML Kickoff',            '1981-08-28',   '1981-09-11'    ),
    ('Model Training',        '1981-09-28',   '1982-12-10'    ),
    ('Model Deployment',      '1982-12-11',   null            );
table proj3;

-- =========================================================
-- gap-free values
select row_number() over (order by 1)
from table(generator(rowcount => 5));
