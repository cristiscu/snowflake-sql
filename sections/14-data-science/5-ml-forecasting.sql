-- ML Forecasting
-- https://docs.snowflake.com/en/user-guide/ml-functions/forecasting
use test.public;

create or replace snowflake.ml.forecast fcast(
    input_data => SYSTEM$QUERY_REFERENCE(
        'SELECT ts, temp FROM weather_view WHERE train'),
    timestamp_colname => 'ts',
    target_colname => 'temp');

show snowflake.ml.forecast;
    
call fcast!forecast(
    forecasting_periods => 30,
    config_object => {'prediction_interval': 0.9});

CALL fcast!SHOW_TRAINING_LOGS();

-- w/ exogenous var (wind)
CREATE OR REPLACE SNOWFLAKE.ML.FORECAST fcast2(
  INPUT_DATA => SYSTEM$QUERY_REFERENCE(
      'SELECT ts, temp, wind FROM weather_view WHERE train'),
  TIMESTAMP_COLNAME => 'ts',
  TARGET_COLNAME => 'temp');

CALL fcast2!FORECAST(
  INPUT_DATA => SYSTEM$QUERY_REFERENCE(
      'SELECT ts, temp, wind FROM weather_view WHERE not train'),
  TIMESTAMP_COLNAME => 'ts');

-- multi-series (bad)
CREATE OR REPLACE SNOWFLAKE.ML.FORECAST fcast3(
  INPUT_DATA => SYSTEM$QUERY_REFERENCE(
      'SELECT bad, ts, temp FROM weather_view WHERE train'),
  SERIES_COLNAME => 'bad',
  TIMESTAMP_COLNAME => 'ts',
  TARGET_COLNAME => 'temp');

CALL fcast3!FORECAST(
  FORECASTING_PERIODS => 3,
  SERIES_VALUE => [2, FALSE]);

-- multi-series (bad) w/ exogenous vars (wind)
CREATE OR REPLACE SNOWFLAKE.ML.FORECAST fcast4(
  INPUT_DATA => SYSTEM$REFERENCE(
    'SELECT bad, ts, temp, wind FROM weather_view WHERE train'),
  SERIES_COLNAME => 'bad',
  TIMESTAMP_COLNAME => 'ts',
  TARGET_COLNAME => 'temp');

CALL fcast4!FORECAST(
  INPUT_DATA => SYSTEM$REFERENCE(
      'SELECT bad, ts, temp, wind FROM weather_view WHERE not train'),
  SERIES_COLNAME => 'bad',
  TIMESTAMP_COLNAME => 'ts');

CALL fcast4!EXPLAIN_FEATURE_IMPORTANCE();
CALL fcast4!SHOW_EVALUATION_METRICS();
