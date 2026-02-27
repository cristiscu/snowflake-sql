-- Dynamic Tables with Immutability Constraints
-- https://www.snowflake.com/en/engineering-blog/dynamic-tables-immutability/
-- https://docs.snowflake.com/en/user-guide/dynamic-tables-immutability-constraints
use test.employees;

CREATE TABLE tx (id INT, ts TIMESTAMP, amount INT);

CREATE DYNAMIC TABLE tx_stats
    TARGET_LAG = '1 minute'
    WAREHOUSE = compute_wh
    IMMUTABLE WHERE (hour < CURRENT_TIMESTAMP() - INTERVAL '1 day')
AS
    SELECT DATE_TRUNC(HOUR, ts) as hour, SUM(amount) as total_amount
    FROM tx
    GROUP BY hour;

CREATE TASK tx_delete_old
    SCHEDULE = '12 hours'
    WAREHOUSE = compute_wh
AS
    DELETE FROM tx
    WHERE ts < CURRENT_TIMESTAMP() - INTERVAL '1 week';