# add to new Python Worksheet
# set warehouse + test.employees
# add faker as package
import snowflake.snowpark as snowpark
from faker import Faker

def main(session: snowpark.Session):
    f = Faker()
    output = [[f.name(), f.address(), f.city(), f.state(), f.email()]
        for _ in range(1000)]
    df = session.create_dataframe(output,
        schema=["name", "address", "city", "state", "email"])
    return df