-- see https://docs.snowflake.com/en/user-guide/ml-powered-contribution-explorer
-- see https://www.snowflake.com/blog/ml-powered-functions-improve-speed-quality/
use test.public;

-- ================================================================
-- separate control+test groups
SELECT ds, country, department, transactions as ct, null as tt
FROM sales
WHERE ds BETWEEN '2020-05-01' AND '2020-05-20'
UNION ALL
SELECT ds, country, department, null as ct, transactions as tt
FROM sales
WHERE ds BETWEEN '2020-08-01' AND '2020-08-20';

(select 'control' as grp, country, department, sum(transactions)
from sales
where ds BETWEEN '2020-05-01' AND '2020-05-20'
group by 1, 2, 3
union all
select 'test' as grp, country, department, sum(transactions)
from sales
where ds BETWEEN '2020-08-01' AND '2020-08-20'
group by 1, 2, 3)
order by 1, 4 DESC;

-- ================================================================
-- TOP_INSIGHTS calls
WITH input AS (
  SELECT
    {
      'country': country,
      'department': department
    } AS categorical_dimensions,
    {
    } AS continuous_dimensions,
    transactions::float AS metric,
    IFF(ds BETWEEN '2020-08-01' AND '2020-08-20', TRUE, FALSE) AS label
  FROM sales
  WHERE (ds BETWEEN '2020-05-01' AND '2020-05-20')
    OR (ds BETWEEN '2020-08-01' AND '2020-08-20'))
SELECT res.*
FROM input, TABLE(
  SNOWFLAKE.ML.TOP_INSIGHTS(
    categorical_dimensions,
    continuous_dimensions,
    metric,
    label
  ) OVER (PARTITION BY 0)) res
ORDER BY surprise DESC;

WITH source AS (
    SELECT *
    FROM sales
    WHERE (ds BETWEEN '2020-05-01' AND '2020-05-20')
        OR (ds BETWEEN '2020-08-01' AND '2020-08-20')),
input AS (
    SELECT
        {
            'country': country,
            'department': department
        } AS cat_dims,
        {
        } AS cont_dims,
        transactions::float AS metric,
        IFF(ds BETWEEN '2020-08-01' AND '2020-08-20', TRUE, FALSE)::boolean AS label
    FROM source),
analysis AS (
    SELECT res.*
    FROM input, 
        TABLE(SNOWFLAKE.ML.TOP_INSIGHTS(cat_dims, cont_dims, metric, label)
        OVER (PARTITION BY 0)) res)
SELECT contributor,
    TRUNC(expected_metric_test) AS expected,
    metric_test AS actual,
    TRUNC(relative_change * 100) || '%' AS ratio
FROM analysis
WHERE ABS(relative_change - 1) > 0.4
    AND NOT ARRAY_TO_STRING(contributor, ',') LIKE '%not%'
ORDER BY relative_change DESC
LIMIT 10;

WITH source AS (
    SELECT *
    FROM sales
    WHERE (ds BETWEEN '2020-05-01' AND '2020-05-20')
        OR (ds BETWEEN '2020-08-01' AND '2020-08-20')),
input AS (
    SELECT
        {
            'country': country,
            'department': department
        } AS cat_dims,
        {
            'transactions': transactions
        } AS cont_dims,
        1.0::float AS metric,
        IFF(ds BETWEEN '2020-08-01' AND '2020-08-20', TRUE, FALSE)::boolean AS label
    FROM source),
analysis AS (
    SELECT res.*
    FROM input, 
        TABLE(SNOWFLAKE.ML.TOP_INSIGHTS(cat_dims, cont_dims, metric, label)
        OVER (PARTITION BY 0)) res)
SELECT contributor,
    TRUNC(expected_metric_test) AS expected,
    metric_test AS actual,
    TRUNC(relative_change * 100) || '%' AS ratio
FROM analysis
WHERE ABS(relative_change - 1) > 0.4
    AND NOT ARRAY_TO_STRING(contributor, ',') LIKE '%not%'
ORDER BY relative_change DESC
LIMIT 10;
