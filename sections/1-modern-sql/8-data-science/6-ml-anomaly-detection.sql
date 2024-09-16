-- ML Anomaly Detection
use test.public;

-- unlabeled/unsupervized
create or replace snowflake.ml.ANOMALY_DETECTION ad(
    input_data => SYSTEM$QUERY_REFERENCE(
        'SELECT ts, temp FROM weather_view WHERE train'),
    TIMESTAMP_COLNAME => 'ts',
    TARGET_COLNAME => 'temp',
    LABEL_COLNAME => '');
SHOW SNOWFLAKE.ML.ANOMALY_DETECTION;
    
call ad!detect_anomalies(
    INPUT_DATA => SYSTEM$QUERY_REFERENCE(
        'SELECT ts, temp FROM weather_view WHERE not train'),
    TIMESTAMP_COLNAME => 'ts',
    TARGET_COLNAME => 'temp');

-- labeled/supervized (w/ extreme as outliers)
CREATE OR REPLACE SNOWFLAKE.ML.ANOMALY_DETECTION ad2(
  INPUT_DATA => SYSTEM$QUERY_REFERENCE(
      'SELECT ts, temp, extreme FROM weather_view WHERE train'),
  TIMESTAMP_COLNAME => 'ts',
  TARGET_COLNAME => 'temp',
  LABEL_COLNAME => 'extreme');

CALL ad2!DETECT_ANOMALIES(
  INPUT_DATA => SYSTEM$QUERY_REFERENCE(
      'SELECT ts, temp FROM weather_view WHERE not train'),
  TIMESTAMP_COLNAME => 'ts',
  TARGET_COLNAME => 'temp');

CALL ad2!EXPLAIN_FEATURE_IMPORTANCE();
