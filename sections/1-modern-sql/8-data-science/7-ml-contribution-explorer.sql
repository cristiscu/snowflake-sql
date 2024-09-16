-- ML Contribution Explorer
use test.public;

WITH input AS (
  SELECT
    { } AS cat_dims,
    { 'wind': wind } AS cont_dims,
    temp::float AS metric,
    bad AS label
  FROM weather_view)
SELECT res.*
FROM input, TABLE(SNOWFLAKE.ML.TOP_INSIGHTS(
    cat_dims, cont_dims, metric, label) OVER (PARTITION BY 0)) res
ORDER BY surprise DESC;