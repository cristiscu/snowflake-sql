/*
add to new Python Worksheet
set warehouse + test.employees
add faker as package

import snowflake.snowpark as snowpark
from faker import Faker

def main(session: snowpark.Session):
    f = Faker()
    output = [[f.name(), f.address(), f.city(), f.state(), f.email()]
        for _ in range(1000)]
    df = session.create_dataframe(output,
        schema=["name", "address", "city", "state", "email"])
    return df
*/

use test.employees;

create or replace procedure gen_fake_rows(num_rows int)
    returns Table()
    language python
    runtime_version = 3.9
    packages =('faker', 'snowflake-snowpark-python')
    handler = 'main'
as $$
import snowflake.snowpark as snowpark
from faker import Faker

def main(session: snowpark.Session, num_rows: int):
  f = Faker()
  output = [[f.name(), f.address(), f.city(), f.state(), f.email()]
    for _ in range(num_rows)]
  df = session.create_dataframe(output,
    schema=["name", "address", "city", "state", "email"])
  return df
$$;

call gen_fake_rows(2000);
