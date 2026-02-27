-- GENERATE_SYNTHETIC_DATA
-- https://docs.snowflake.com/en/user-guide/synthetic-data
-- https://docs.snowflake.com/en/sql-reference/stored-procedures/generate_synthetic_data
USE test.employees;
TABLE EMP;

DROP TABLE IF EXISTS EMP_SYNTHETIC;
CALL SNOWFLAKE.DATA_PRIVACY.GENERATE_SYNTHETIC_DATA({
    'datasets':[{
        'input_table': 'TEST.EMPLOYEES.EMP',
        'output_table': 'TEST.EMPLOYEES.EMP_SYNTHETIC'
    }]
});
TABLE EMP_SYNTHETIC;

-- =============================================================
CREATE OR REPLACE VIEW TPC_ORDERS_5K
AS (SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS LIMIT 5000);
CREATE OR REPLACE VIEW TPC_CUSTOMERS_5K
AS (SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER LIMIT 5000);
TABLE TPC_ORDERS_5K;
TABLE TPC_CUSTOMERS_5K;

CREATE OR REPLACE SECRET my_secret
    TYPE = SYMMETRIC_KEY
    ALGORITHM = GENERIC;

CALL SNOWFLAKE.DATA_PRIVACY.GENERATE_SYNTHETIC_DATA({
    'datasets':[{
        'input_table': 'TEST.EMPLOYEES.TPC_ORDERS_5K',
        'output_table': 'TEST.EMPLOYEES.TPC_ORDERS_5K_SYNTHETIC',
        'columns': {'O_CUSTKEY': {'join_key': True}}
    },{
        'input_table': 'TEST.EMPLOYEES.TPC_CUSTOMERS_5K',
        'output_table': 'TEST.EMPLOYEES.TPC_CUSTOMERS_5K_SYNTHETIC',
        'columns' : {'C_CUSTKEY': {'join_key': True, 'categorical': False}}
    }],
    'replace_output_tables': True,
    'similarity_filter': True,
    'consistency_secret': SYSTEM$REFERENCE('SECRET', 'MY_SECRET', 'SESSION', 'READ')::STRING
});
TABLE TPC_ORDERS_5K_SYNTHETIC;
TABLE TPC_CUSTOMERS_5K_SYNTHETIC;
