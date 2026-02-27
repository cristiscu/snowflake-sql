-- RESAMPLE for time series, w/ INTERPOLATE_ window functions
-- https://docs.snowflake.com/en/sql-reference/constructs/resample
-- https://docs.snowflake.com/en/sql-reference/functions/interpolate_bfill 
use test.employees;

-- RESAMPLE sequential integer number (unixtime)
CREATE OR REPLACE TABLE sensor_data_unixtime (
    device_id VARCHAR(10),
    unixtime NUMBER(38,0),
    avg_temp NUMBER(6,4),
    vibration NUMBER (5,4),
    motor_rpm INT);
INSERT INTO sensor_data_unixtime VALUES
    ('DEVICE3', 1696150802, 36.1103, 0.4226, 1560),
    ('DEVICE3', 1696150803, 35.2987, 0.4326, 1561),
    ('DEVICE3', 1696150804, 40.0001, 0.3221, 1562),
    ('DEVICE3', 1696150805, 38.0422, 0.3333, 1589),
    ('DEVICE3', 1696150807, 33.1524, 0.4865, 1499),
    ('DEVICE3', 1696150808, 32.0422, 0.4221, 1498),
    ('DEVICE3', 1696150809, 31.1519, 0.4751, 1600),
    ('DEVICE3', 1696150810, 29.1524, 0.4639, 1605),
    ('DEVICE3', 1696150812, 35.2987, 0.4336, 1585),
    ('DEVICE3', 1696150813, 40.0000, 0.4226, 1560);
table sensor_data_unixtime;

SELECT *
FROM sensor_data_unixtime
RESAMPLE(
    USING unixtime
    INCREMENT BY 1
    METADATA_COLUMNS
        IS_GENERATED() AS gen_row,
        BUCKET_START())
ORDER BY unixtime;

-- =======================================================================
-- RESAMPLE sequential timestamp value (observed)
-- https://docs.snowflake.com/en/user-guide/querying-time-series-data#label-using-the-resample-clause
CREATE OR REPLACE TABLE march_temps (
    observed TIMESTAMP,
    temperature INT, 
    city VARCHAR(20), 
    county VARCHAR(20));
INSERT INTO march_temps VALUES
    ('2025-03-15 09:50:00.000',44,'South Lake Tahoe','El Dorado'),
    ('2025-03-15 09:55:00.000',46,'South Lake Tahoe','El Dorado'),
    ('2025-03-15 10:10:00.000',52,'South Lake Tahoe','El Dorado'),
    ('2025-03-15 10:15:00.000',54,'South Lake Tahoe','El Dorado'),
    ('2025-03-15 09:49:00.000',48,'Big Bear City','San Bernardino'),
    ('2025-03-15 09:55:00.000',49,'Big Bear City','San Bernardino'),
    ('2025-03-15 10:10:00.000',51,'Big Bear City','San Bernardino'),
    ('2025-03-15 10:18:00.000',54,'Big Bear City','San Bernardino');
table march_temps;

SELECT *
FROM march_temps
RESAMPLE (
    USING observed
    INCREMENT BY INTERVAL '5 minutes')
ORDER BY observed;

SELECT *
FROM march_temps
RESAMPLE (
    USING observed
    INCREMENT BY INTERVAL '5 minutes'
    PARTITION BY city, county)
ORDER BY city, county, observed;

-- =======================================================================
-- RESAMPLE sequential date value (metric_date), w/ interpolations for missing measures
-- https://www.snowflake.com/en/engineering-blog/new-sql-features-public-preview/
-- https://docs.snowflake.com/en/user-guide/querying-time-series-data#label-gap-filling-with-resample-interpolate
CREATE OR REPLACE TABLE daily_store_metrics (
    metric_date DATE,
    store_id INT,
    daily_revenue INT,
    active_promotion_id INT);
INSERT INTO daily_store_metrics VALUES
    ('2025-09-01', 1, 10000, 101),      -- Day 1: Revenue & new promotion
    ('2025-09-03', 1, 11000, NULL),     -- Day 3: Revenue, no promo change
    ('2025-09-06', 1, 12500, 202);      -- Day 6: Revenue & new promotion
table daily_store_metrics;

SELECT metric_date, store_id,
    INTERPOLATE_LINEAR(daily_revenue)       -- estimate revenue on missing days
        OVER (PARTITION BY store_id ORDER BY metric_date) AS estimated_revenue,
    INTERPOLATE_FFILL(active_promotion_id)  -- forward-fill for daily active promotion
        OVER (PARTITION BY store_id ORDER BY metric_date) AS promotion_in_effect
FROM daily_store_metrics
RESAMPLE (
    USING metric_date
    INCREMENT BY INTERVAL '1 day'
    PARTITION BY store_id);