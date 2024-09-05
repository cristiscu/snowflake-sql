-- see https://docs.snowflake.com/en/user-guide/ml-powered-contribution-explorer#example
USE SCHEMA test.public;

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