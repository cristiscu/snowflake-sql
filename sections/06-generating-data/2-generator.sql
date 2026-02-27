-- Synthetic Data Generation
USE SCHEMA test.public;

-- ==============================================================
-- Regression Data Generation
-- https://docs.snowflake.com/en/user-guide/ml-powered-contribution-explorer#example

CREATE OR REPLACE TABLE time_series(
    date DATE, sales NUMBER,
    country VARCHAR, category VARCHAR);

-- training data
INSERT INTO time_series
  SELECT
    DATEADD(day, SEQ4(), DATE_FROM_PARTS(2020, 4, 1)) AS date,
    UNIFORM(1, 10, RANDOM()) AS sales,
    'usa' AS country,
    'tech' AS category
  FROM TABLE(GENERATOR(ROWCOUNT => 365));

INSERT INTO time_series
  SELECT
    DATEADD(day, SEQ4(), DATE_FROM_PARTS(2020, 4, 1)) AS date,
    UNIFORM(1, 10, RANDOM()) AS sales,
    'usa' AS country,
    'auto' AS category
  FROM TABLE(GENERATOR(ROWCOUNT => 365));

INSERT INTO time_series
  SELECT
    DATEADD(day, seq4(), DATE_FROM_PARTS(2020, 4, 1)) AS date,
    UNIFORM(1, 10, RANDOM()) AS sales,
    'usa' AS country,
    'fashion' AS category
  FROM TABLE(GENERATOR(ROWCOUNT => 365));

INSERT INTO time_series
  SELECT
    DATEADD(day, SEQ4(), DATE_FROM_PARTS(2020, 4, 1)) AS date,
    UNIFORM(1, 10, RANDOM()) AS sales,
    'usa' AS country,
    'finance' AS category
  FROM TABLE(GENERATOR(ROWCOUNT => 365));

INSERT INTO time_series
  SELECT
    DATEADD(day, SEQ4(), DATE_FROM_PARTS(2020, 4, 1)) AS date,
    UNIFORM(1, 10, RANDOM()) AS sales,
    'canada' AS country,
    'fashion' AS category
  FROM TABLE(GENERATOR(ROWCOUNT => 365));

INSERT INTO time_series
  SELECT
    DATEADD(day, SEQ4(), DATE_FROM_PARTS(2020, 4, 1)) AS date,
    UNIFORM(1, 10, RANDOM()) AS sales,
    'canada' AS country,
    'finance' AS category
  FROM TABLE(GENERATOR(ROWCOUNT => 365));

INSERT INTO time_series
  SELECT
    DATEADD(day, SEQ4(), DATE_FROM_PARTS(2020, 4, 1)) AS date,
    UNIFORM(1, 10, RANDOM()) AS sales,
    'canada' AS country,
    'tech' AS category
  FROM TABLE(GENERATOR(ROWCOUNT => 365));

INSERT INTO time_series
  SELECT
    DATEADD(day, SEQ4(), DATE_FROM_PARTS(2020, 4, 1)) AS date,
    UNIFORM(1, 10, RANDOM()) AS sales,
    'canada' AS country,
    'auto' AS category
  FROM TABLE(GENERATOR(ROWCOUNT => 365));

INSERT INTO time_series
  SELECT
    DATEADD(day, SEQ4(), DATE_FROM_PARTS(2020, 4, 1)) AS date,
    UNIFORM(1, 10, RANDOM()) AS sales,
    'france' AS country,
    'fashion' AS category
  FROM TABLE(GENERATOR(ROWCOUNT => 365));

INSERT INTO time_series
  SELECT
    DATEADD(day, SEQ4(), DATE_FROM_PARTS(2020, 4, 1)) AS date,
    UNIFORM(1, 10, RANDOM()) AS sales,
    'france' AS country,
    'finance' AS category
  FROM TABLE(GENERATOR(ROWCOUNT => 365));

INSERT INTO time_series
  SELECT
    DATEADD(day, SEQ4(), DATE_FROM_PARTS(2020, 4, 1)) AS date,
    UNIFORM(1, 10, RANDOM()) AS sales,
    'france' AS country,
    'tech' AS category
  FROM TABLE(GENERATOR(ROWCOUNT => 365));

INSERT INTO time_series
  SELECT
    DATEADD(day, SEQ4(), DATE_FROM_PARTS(2020, 4, 1)) AS date,
    UNIFORM(1, 10, RANDOM()) AS sales,
    'france' AS country,
    'auto' AS category
  FROM TABLE(GENERATOR(ROWCOUNT => 365));

-- test data
INSERT INTO time_series
  SELECT
    DATEADD(day, SEQ4(), DATE_FROM_PARTS(2020, 8, 1)) AS date,
    UNIFORM(300, 320, RANDOM()) AS sales,
    'usa' AS country,
    'auto' AS dim_vertica
  FROM TABLE(GENERATOR(ROWCOUNT => 365));

INSERT INTO time_series
  SELECT
    DATEADD(day, SEQ4(), DATE_FROM_PARTS(2020, 8, 1))  AS date,
    UNIFORM(400, 420, RANDOM()) AS sales,
    'usa' AS country,
    'finance' AS category
  FROM TABLE(GENERATOR(ROWCOUNT => 365));

SELECT * FROM time_series;

-- ==============================================================
-- Classification Data Generation
-- https://docs.snowflake.com/user-guide/snowflake-cortex/ml-functions/classification#setting-up-the-data-for-the-examples

CREATE OR REPLACE TABLE purchases AS (
    -- train data
    SELECT
        CAST(UNIFORM(0, 4, RANDOM()) as VARCHAR) as interest,
        UNIFORM(0, 3, RANDOM()) as rating,
        FALSE AS label,
        'not_interested' AS class
    FROM TABLE(GENERATOR(rowCount => 100))
    UNION ALL
    SELECT
        CAST(UNIFORM(4, 7, RANDOM()) AS VARCHAR) AS interest,
        UNIFORM(3, 7, RANDOM()) AS rating,
        FALSE AS label,
        'add_to_wishlist' AS class
    FROM TABLE(GENERATOR(rowCount => 100))
    UNION ALL
    SELECT
        CAST(UNIFORM(7, 10, RANDOM()) AS VARCHAR) AS interest,
        UNIFORM(7, 10, RANDOM()) AS rating,
        TRUE as label,
        'purchase' AS class
    FROM TABLE(GENERATOR(rowCount => 100))
    UNION ALL

    -- test data
    SELECT
        CAST(UNIFORM(0, 4, RANDOM()) AS VARCHAR) AS interest,
        UNIFORM(0, 3, RANDOM()) AS rating,
        NULL as label,
        NULL AS class
    FROM TABLE(GENERATOR(rowCount => 100))
    UNION ALL
    SELECT
        CAST(UNIFORM(4, 7, RANDOM()) AS VARCHAR) AS interest,
        UNIFORM(3, 7, RANDOM()) AS rating,
        NULL as label,
        NULL AS class
    FROM TABLE(GENERATOR(rowCount => 100))
    UNION ALL
    SELECT
        CAST(UNIFORM(7, 10, RANDOM()) AS VARCHAR) AS interest,
        UNIFORM(7, 10, RANDOM()) AS rating,
        NULL as label,
        NULL AS class
    FROM TABLE(GENERATOR(rowCount => 100))
);
select * from purchases;
