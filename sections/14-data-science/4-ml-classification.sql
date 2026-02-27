-- ML Classification
-- https://docs.snowflake.com/en/user-guide/ml-functions/classification
use test.public;

CREATE OR REPLACE SNOWFLAKE.ML.CLASSIFICATION cls(
    INPUT_DATA => SYSTEM$QUERY_REFERENCE(
        'SELECT temp, wind, bad FROM weather_view WHERE train'),
    TARGET_COLNAME => 'bad');
SHOW snowflake.ml.classification;

SELECT temp, wind, bad, cls!PREDICT(
    INPUT_DATA => object_construct(*)) as bad_pred
FROM weather_view
WHERE not train;

CALL cls!SHOW_EVALUATION_METRICS();
CALL cls!SHOW_GLOBAL_EVALUATION_METRICS();
CALL cls!SHOW_THRESHOLD_METRICS();

CALL cls!SHOW_CONFUSION_MATRIX();
CALL cls!SHOW_FEATURE_IMPORTANCE();
CALL cls!SHOW_TRAINING_LOGS();