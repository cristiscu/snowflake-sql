use test.public;

-- =================================================================
-- SQL or Snowflake Scripting

-- Snowflake Scripting stored procedure
create or replace procedure procSQL(num float)
    returns string not null
    language sql
as
begin
    return '+' || to_varchar(num);
end;

call procSQL(22.5);
select * from table(result_scan(last_query_id()));

-- SQL UDF
create or replace function fctSQL(num float) returns string
as 'select ''+'' || to_varchar(num)';

select fctSQL(22.5);

-- SQL UDTF
create or replace function fcttSQL(s string)
    returns table(out varchar)
as $$
    select s
    union all
    select s
$$;

select * from table(fcttSQL('abc'));

-- =================================================================
-- JavaScript

-- JavaScript stored procedure
create or replace procedure procJavaScript(num float)
    returns string not null
    language javascript
    strict
as $$
    return '+' + NUM.toString();
$$;

call procJavaScript(22.5);
select * from table(result_scan(last_query_id()));

-- JavaScript UDF
create or replace function fctJavaScript(num float)
    returns string not null
    language javascript
    strict
as 'return \'+\' + NUM.toString()';

select fctJavaScript(22.5);

-- JavaScript UDTF
create or replace function fcttJavaScript(s string)
    returns table(out varchar)
    language javascript
    strict
as $$
{
    processRow: function f(row, rowWriter, context)
    {
        rowWriter.writeRow({OUT: row.S});
        rowWriter.writeRow({OUT: row.S});
    }
}
$$;

select * from table(fcttJavaScript('abc'));

-- =================================================================
-- Python

-- Python stored procedure (only w/ Snowpark!)
create or replace procedure procPythonS(num float)
    returns string
    language python
    runtime_version = '3.10'
    packages = ('snowflake-snowpark-python')
    handler = 'proc1'
as $$
import snowflake.snowpark as snowpark

def proc1(session: snowpark.Session, num: float):
    query = f"select '+' || to_char({num})"
    return session.sql(query).collect()[0][0]
$$;

call procPythonS(22.5);

-- Python UDF
create or replace function fctPython(num float)
    returns string
    language python
    runtime_version = '3.10'
    handler = 'proc1'
as $$
def proc1(num: float):
    return '+' + str(num)
$$;

select fctPython(22.5);

-- Python UDTF
create or replace function fcttPython(s string)
    returns table(out varchar)
    language python
    runtime_version = '3.10'
    handler = 'MyClass'
as $$
class MyClass:
    def process(self, s: str):
        yield (s,)
        yield (s,)
$$;

select * from table(fcttPython('abc'));

-- =================================================================
-- Java

-- Java stored procedure (only w/ Snowpark!)
create or replace procedure procJavaS(num float)
    returns string
    language java
    runtime_version = 11
    packages = ('com.snowflake:snowpark:latest')
    handler = 'MyClass.proc1'
as $$
    import com.snowflake.snowpark_java.*;

    class MyClass {
        public String proc1(Session session, float num) {
            String query = "select '+' || to_char(" + num + ")";
            return session.sql(query).collect()[0].getString(0);
        }
    }
$$;

call procJavaS(22.5);

-- Java UDF
create or replace function fctJava(num float)
    returns string
    language java
    runtime_version = 11
    handler = 'MyClass.fct1'
as $$
    class MyClass {
        public String fct1(float num) {
            return "+" + Float.toString(num);
        }
    }
$$;

select fctJava(22.5);

-- Java UDTF
create or replace function fcttJava(s string)
    returns table(out varchar)
    language java
    runtime_version = 11
    handler = 'MyClass'
as $$
    import java.util.stream.Stream;

    class OutputRow {
        public String out;
        public OutputRow(String outVal) { this.out = outVal; }
    }
    class MyClass {
        public static Class getOutputClass() { return OutputRow.class; } 
        public Stream<OutputRow> process(String inVal)
        { return Stream.of(new OutputRow(inVal), new OutputRow(inVal)); }
    }
$$;

select * from table(fcttJava('abc'));

-- =================================================================
-- Scala

-- Scala stored procedure (only w/ Snowpark!)
create or replace procedure procScalaS(num float)
    returns string
    language scala
    runtime_version = 2.12
    packages = ('com.snowflake:snowpark:latest')
    handler = 'MyClass.proc1'
as $$
    import com.snowflake.snowpark.Session;

    object MyClass {
        def proc1(session: Session, num: Float): String = {
            var query = "select '+' || to_char(" + num + ")"
            return session.sql(query).collect()(0).getString(0)
        }
    }
$$;

call procScalaS(22.5);

-- Scala UDF
create or replace function fctScala(num float)
    returns string
    language scala
    runtime_version = 2.12
    handler = 'MyClass.fct1'
as $$
    object MyClass {
        def fct1(num: Float): String = {
            return "+" + num.toString
        }
    }
$$;

select fctScala(22.5);
