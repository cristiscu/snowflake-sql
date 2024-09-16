from snowflake.snowpark import Session
from snowflake.ml.utils.connection_params import SnowflakeLoginOptions

session = Session.builder.configs(SnowflakeLoginOptions("test_conn")).create()
session.query_tag = "model-registry-1"

from snowflake.ml.registry import Registry

registry = Registry(session=session)    # database_name="TEST", schema_name="PUBLIC"

# CREATE MODEL TEST.PUBLIC.RANDOMFORESTREGRESSOR WITH VERSION V1
# FROM @TEST.PUBLIC.SNOWPARK_TEMP_STAGE_.../model
model_ref = registry.log_model(
    model,
    model_name="RandomForestRegressor",
    version_name="v2",
    conda_dependencies=["scikit-learn"])