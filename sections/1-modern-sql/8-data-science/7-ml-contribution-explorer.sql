-- ML Contribution Explorer: in Titanic dataset
USE TEST.PUBLIC;

-- TEST.PUBLIC.TITANIC must be previously created from the uploaded TITANIC.CSV
SELECT * FROM TITANIC;

SELECT (survived=1) as survived, pclass, sex, age, fare, sibsp, parch
FROM TITANIC
WHERE age is not null;

-- template
WITH source AS (
    <your top query here>
), input AS (
    SELECT
        {
            <your optional categorical variable(s) here, in JSON format>
        } AS cat_dims,
        {
            <your optional continuous variable(s) here, in JSON format>
        } AS cont_dims,
        <your optional metric column here (1.0 if none)>::float AS metric,
        <your dataset split variable here>::boolean AS label
    FROM source
), analysis AS (
    SELECT res.*
    FROM input, 
        TABLE(SNOWFLAKE.ML.TOP_INSIGHTS(cat_dims, cont_dims, metric, label)
        OVER (PARTITION BY 0)) res
) SELECT contributor,
    TRUNC(expected_metric_test) AS expected,
    metric_test AS actual,
    TRUNC(relative_change * 100) || '%' AS ratio
FROM analysis
WHERE ABS(relative_change - 1) > 0.4
    AND NOT ARRAY_TO_STRING(contributor, ',') LIKE '%not%'
ORDER BY relative_change DESC
LIMIT 10;

-- what features+segments made some people survive?
WITH source AS (
    SELECT (survived=1) as survived, pclass, sex, age, fare, sibsp, parch
    FROM TITANIC
    WHERE age is not null
), input AS (
    SELECT
        {
            'pclass': pclass,
            'sex' : sex,
            'sibsp': sibsp,
            'parch': parch
        } AS cat_dims,
        {
            'age': age,
            'fare': fare
        } AS cont_dims,
        1.0::float AS metric,
        survived::boolean AS label
    FROM source
), analysis AS (
    SELECT res.*
    FROM input, 
        TABLE(SNOWFLAKE.ML.TOP_INSIGHTS(cat_dims, cont_dims, metric, label)
        OVER (PARTITION BY 0)) res
) SELECT contributor,
    TRUNC(expected_metric_test) AS expected,
    metric_test AS actual,
    TRUNC(relative_change * 100) || '%' AS ratio
FROM analysis
WHERE ABS(relative_change - 1) > 0.4
    AND NOT ARRAY_TO_STRING(contributor, ',') LIKE '%not%'
ORDER BY relative_change DESC
LIMIT 10;

SELECT survived, sex, count(*)
FROM TITANIC
group by 1, 2
order by 1, 2;

SELECT survived, IFF(fare < 48.2, 'POOR', 'RICH') AS status, count(*)
FROM TITANIC
group by 1, 2
order by 1, 2;
