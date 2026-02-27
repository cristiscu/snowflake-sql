-- Geospatial Data Types
-- https://docs.snowflake.com/en/sql-reference/data-types-geospatial

-- GET "OpenStreetMap New York" dataset (from Sonra) for free from the Marketplace
-- https://app.snowflake.com/marketplace/listing/GZSVZ3XQXH/sonra-openstreetmap-new-york
USE OPENSTREETMAP_NEW_YORK.NEW_YORK;

// Give me the length of a Way
SELECT ID, ST_LENGTH(COORDINATES) AS LENGTH
FROM V_OSM_NY_WAY;

// List the number of nodes in a Way
SELECT ID, ST_NPOINTS(COORDINATES) AS NUM_OF_NODES
FROM V_OSM_NY_WAY;

// Give me the distance between two Ways
SELECT A.ID AS ID_1, B.ID AS ID_2,
    ST_DISTANCE(A.COORDINATES, B.COORDINATES) AS DISTANCE
FROM (
    SELECT ID, COORDINATES
    FROM V_OSM_NY_WAY
    WHERE ID = 5711054) AS A
INNER JOIN (
    SELECT ID, COORDINATES
    FROM V_OSM_NY_WAY
    WHERE ID = 5711055) AS B;

// Give me all amenities from education category in a radius of 2,000 metres from a point
SELECT *
FROM V_OSM_NY_AMENITY_EDUCATION
WHERE ST_DWITHIN(ST_POINT(-74.00296211242676, 40.72143702499928), COORDINATES, 2000);

// Give me all food and beverage Shops in a radius of 2,000 metres from a point
SELECT *
FROM V_OSM_NY_SHOP_FOOD_BEVERAGES
WHERE ST_DWITHIN(ST_POINT(-74.00296211242676, 40.72143702499928), COORDINATES, 2000);
