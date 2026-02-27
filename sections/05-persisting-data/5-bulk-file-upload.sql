-- Bulk File Upload
-- https://docs.snowflake.com/en/user-guide/data-load-local-file-system
use test.employees;

-- =======================================================
-- (1) staged files upload
CREATE STAGE IF NOT EXISTS stage_load;

// PUT file://C:\Projects\snowflake-sql\sections\05-persisting-data\5-emp.csv @stage_load
//     overwrite=true auto_compress=false;

-- manually upload the CSV file here instead!

/*
EMPNO,ENAME,JOB,MGR,HIREDATE,SAL,COMM,DNAME
7839,KING,PRESIDENT,,1981-11-17,5000,,Accounting
7698,BLAKE,MANAGER,7839,1981-05-01,2850,,Sales
7654,MARTIN,SALESMAN,7698,1981-09-28,1250,1400,Sales
7499,ALLEN,SALESMAN,7698,1981-02-20,1600,300.5,Sales
7521,WARD,SALESMAN,7698,1981-02-22,1250,500,Sales
7900,JAMES,CLERK,7698,1981-12-03,950,,Sales
7844,TURNER,SALESMAN,7698,1981-09-08,1500,0,Sales
7782,CLARK,MANAGER,7839,1981-06-09,2450.5,,Accounting
7934,MILLER,CLERK,7782,1982-01-23,1300,,Accounting
7566,JONES,MANAGER,7839,1981-04-02,2975.8,,Research
7788,SCOTT,ANALYST,7566,1982-12-09,3000,,Research
7876,ADAMS,CLERK,7788,1983-01-12,1100,,Research
7902,FORD,ANALYST,7566,1981-12-03,3000,,Research
7369,SMITH,CLERK,7902,1980-12-17,800,,Research
*/

SELECT $1 FROM @stage_load/5-emp.csv;

SELECT METADATA$FILE_ROW_NUMBER as RowId,
    METADATA$FILENAME as FileName,
	$1, $2, $3, $4, $5, $6, $7, $8
FROM @stage_load/5-emp.csv;

-- =======================================================
-- (2) schema inference
CREATE OR REPLACE TABLE EMP2 (
	EMPNO		integer,
	ENAME       string,
	JOB         string,
	MGR      	integer,
	HIREDATE   	date,
	SAL      	float,
	COMM  		float,
	DNAME     	string);

CREATE FILE FORMAT IF NOT EXISTS format_csv
	TYPE = CSV
	PARSE_HEADER = TRUE;

SELECT * FROM TABLE(INFER_SCHEMA(
  	LOCATION => '@stage_load',
  	FILES => '5-emp.csv',
  	FILE_FORMAT => 'format_csv'));

SELECT GENERATE_COLUMN_DESCRIPTION(
  	ARRAY_AGG(OBJECT_CONSTRUCT(*)), 'table') AS COLUMNS
FROM TABLE(INFER_SCHEMA(
	LOCATION => '@stage_load',
	FILES => '5-emp.csv',
	FILE_FORMAT => 'format_csv'));

CREATE OR REPLACE TABLE EMP3 USING TEMPLATE (
  	SELECT ARRAY_AGG(OBJECT_CONSTRUCT(*))
  	FROM TABLE(INFER_SCHEMA(
		LOCATION => '@stage_load',
		FILES => '5-emp.csv',
		FILE_FORMAT => 'format_csv')));
DESCRIBE TABLE EMP3;
select GET_DDL('TABLE', 'EMP3');

-- =======================================================
-- (3) bulk data loading
COPY INTO EMP3 FROM @stage_load
   FILES = ('5-emp.csv')
   FILE_FORMAT = (FORMAT_NAME = format_csv)
   MATCH_BY_COLUMN_NAME = CASE_SENSITIVE
   FORCE = TRUE;
select * from EMP3;
