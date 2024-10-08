-- ML Forecasting: sales forecast
-- see https://docs.snowflake.com/en/user-guide/ml-powered-forecasting
USE SCHEMA test.public;

// ===================================================
-- create views
SELECT * FROM sales_ts;

-- for store 1 only
CREATE OR REPLACE VIEW view1_train AS
  SELECT date, sales, outlier, temperature, humidity, holiday
  FROM sales_ts
  WHERE date < '2020-01-15' AND store_id=1 AND item='jacket';
SELECT * FROM view1_train;

CREATE OR REPLACE VIEW view1_test AS
  SELECT date, sales, outlier, temperature, humidity, holiday
  FROM sales_ts
  WHERE date >= '2020-01-15' AND store_id=1 and item='jacket';
SELECT * FROM view1_test;

-- for store 2 only
CREATE OR REPLACE VIEW view2_train AS
  SELECT date, sales, outlier, temperature, humidity, holiday
  FROM sales_ts
  WHERE date < '2020-01-15' AND store_id=2 AND item='umbrella';
SELECT * FROM view2_train;

CREATE OR REPLACE VIEW view2_test AS
  SELECT date, sales, outlier, temperature, humidity, holiday
  FROM sales_ts
  WHERE date >= '2020-01-15' AND store_id=2 and item='umbrella';
SELECT * FROM view2_test;

-- for both stores
CREATE OR REPLACE VIEW view_train AS
  SELECT [store_id, item] AS store_item,
    date, sales, outlier, temperature, humidity, holiday
  FROM sales_ts
  WHERE date < '2020-01-15';
SELECT * FROM view_train;

CREATE OR REPLACE VIEW view_test AS
  SELECT [store_id, item] AS store_item,
    date, sales, outlier, temperature, humidity, holiday
  FROM sales_ts
  WHERE date >= '2020-01-15';
SELECT * FROM view_test;

// ===================================================
// single-series forecast
SELECT date, sales FROM view1_train;

CREATE OR REPLACE SNOWFLAKE.ML.FORECAST fore1(
  INPUT_DATA => SYSTEM$QUERY_REFERENCE('SELECT date, sales FROM view1_train'),
  TIMESTAMP_COLNAME => 'date',
  TARGET_COLNAME => 'sales');
SHOW SNOWFLAKE.ML.FORECAST;

CALL fore1!FORECAST(FORECASTING_PERIODS => 3);

BEGIN
  CALL fore1!FORECAST(FORECASTING_PERIODS => 3);
  LET x := SQLID;
  CREATE OR REPLACE TABLE sales_forecasts AS SELECT * FROM TABLE(RESULT_SCAN(:x));
END;
SELECT * FROM sales_forecasts;

SELECT date AS ts, sales AS actual,
  NULL AS forecast, NULL AS lower_bound, NULL AS upper_bound
  FROM view1_train
UNION ALL
SELECT ts, NULL AS actual,
  forecast, lower_bound, upper_bound
  FROM sales_forecasts;

CALL fore1!FORECAST(
  FORECASTING_PERIODS => 3,
  CONFIG_OBJECT => {'prediction_interval': 0.8});

// ===================================================
// training logs
CALL fore1!SHOW_TRAINING_LOGS();

INSERT INTO sales_ts VALUES
  (1, 'jacket', to_timestamp_ntz('2020-01-03'), 5.0, false, 54, 0.2, 'duplicate');

CREATE OR REPLACE SNOWFLAKE.ML.FORECAST fore1(
  INPUT_DATA => SYSTEM$QUERY_REFERENCE('SELECT date, sales FROM view1_train'),
  TIMESTAMP_COLNAME => 'date',
  TARGET_COLNAME => 'sales',
  CONFIG_OBJECT => {'ON_ERROR': 'SKIP'});
CALL fore1!SHOW_TRAINING_LOGS();

DELETE FROM sales_ts WHERE holiday = 'duplicate';

// ===================================================
// single-series forecast w/ exogenous vars
CREATE OR REPLACE SNOWFLAKE.ML.FORECAST fore2(
  INPUT_DATA => SYSTEM$QUERY_REFERENCE($$
SELECT date, sales, temperature, humidity, holiday
FROM view1_train
$$),
  TIMESTAMP_COLNAME => 'date',
  TARGET_COLNAME => 'sales');

CALL fore2!FORECAST(
  INPUT_DATA => SYSTEM$QUERY_REFERENCE($$
SELECT date, sales, temperature, humidity, holiday
FROM view1_test
$$),
  TIMESTAMP_COLNAME => 'date');

// ===================================================
// multi-series forecast
CREATE OR REPLACE SNOWFLAKE.ML.FORECAST fore3(
  INPUT_DATA => SYSTEM$QUERY_REFERENCE('SELECT store_item, date, sales FROM view_train'),
  SERIES_COLNAME => 'store_item',     -- [store_id, item] multiple TS
  TIMESTAMP_COLNAME => 'date',
  TARGET_COLNAME => 'sales');

CALL fore3!FORECAST(
  FORECASTING_PERIODS => 3,
  SERIES_VALUE => [2,'umbrella']);

// ===================================================
// multi-series forecast w/ exogenous vars
CREATE OR REPLACE SNOWFLAKE.ML.FORECAST fore4(
  INPUT_DATA => SYSTEM$REFERENCE('VIEW', 'view_train'),
  SERIES_COLNAME => 'store_item',
  TIMESTAMP_COLNAME => 'date',
  TARGET_COLNAME => 'sales');

CALL fore4!FORECAST(
  INPUT_DATA => SYSTEM$REFERENCE('VIEW', 'view_test'),
  SERIES_COLNAME => 'store_item',
  TIMESTAMP_COLNAME => 'date');

CALL fore4!EXPLAIN_FEATURE_IMPORTANCE();
CALL fore4!SHOW_EVALUATION_METRICS();
