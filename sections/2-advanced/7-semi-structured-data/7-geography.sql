use openstreetmap_new_york.new_york;

// GeoJSON
show parameters like 'geography_output_format' in session;
// alter session set geography_output_format = 'WKT';

// Query the v_osm_ny_shop_electronics view for rows of type 'node' (long/lat points)
select coordinates, name
from v_osm_ny_shop_electronics
where type = 'node'
limit 25;

// Give me the length of a Way
SELECT ID, ST_LENGTH(COORDINATES) AS LENGTH
FROM V_OSM_NY_WAY;

// List the number of nodes in a Way
SELECT ID, ST_NPOINTS(COORDINATES) AS NUM_OF_NODES
FROM V_OSM_NY_WAY;

// Give me the distance between two Ways
SELECT A.ID ID_1, B.ID ID_2, ST_DISTANCE(A.COORDINATES, B.COORDINATES) AS DISTANCE
FROM (SELECT ID, COORDINATES FROM V_OSM_NY_WAY WHERE ID = 5711054) AS A
INNER JOIN (SELECT ID, COORDINATES FROM V_OSM_NY_WAY WHERE ID = 5711055) AS B;

// Give me all amenities from education category in a radius of 2,000 metres from a point
SELECT *
FROM V_OSM_NY_AMENITY_EDUCATION
WHERE ST_DWITHIN(ST_POINT(-74.00296211242676, 40.72143702499928), COORDINATES, 2000);

// Give me all food and beverage Shops in a radius of 2,000 metres from a point
SELECT *
FROM V_OSM_NY_SHOP_FOOD_BEVERAGES  
WHERE ST_DWITHIN(ST_POINT(-74.00296211242676, 40.72143702499928), COORDINATES, 2000);

select to_geography('POINT(-73.986226 40.755702)');

with locations as (
(select to_geography('POINT(-73.986226 40.755702)') as coordinates, 
0 as distance_meters)
union all
(select coordinates, 
st_distance(coordinates,to_geography('POINT(-73.986226 40.755702)'))::number(6,2) 
as distance_meters from v_osm_ny_shop_electronics 
where name = 'Best Buy' and 
st_dwithin(coordinates,st_makepoint(-73.986226, 40.755702),1600) = true 
order by 2 limit 1)
union all
(select coordinates, 
st_distance(coordinates,to_geography('POINT(-73.986226 40.755702)'))::number(6,2) 
as distance_meters from v_osm_ny_shop_food_beverages 
where shop = 'alcohol' and 
st_dwithin(coordinates,st_makepoint(-73.986226, 40.755702),1600) = true 
order by 2 limit 1)
union all
(select coordinates, 
st_distance(coordinates,to_geography('POINT(-73.986226 40.755702)'))::number(6,2) 
as distance_meters from v_osm_ny_shop_food_beverages 
where shop = 'coffee' and 
st_dwithin(coordinates,st_makepoint(-73.986226, 40.755702),1600) = true 
order by 2 limit 1))
select st_makeline(st_collect(coordinates),to_geography('POINT(-73.986226 40.755702)'))
as linestring from locations;

with locations as (
(select to_geography('POINT(-73.986226 40.755702)') as coordinates, 
0 as distance_meters)
union all
(select coordinates, 
st_distance(coordinates,to_geography('POINT(-73.986226 40.755702)'))::number(6,2) 
as distance_meters from v_osm_ny_shop_electronics 
where name = 'Best Buy' and 
st_dwithin(coordinates,st_makepoint(-73.986226, 40.755702),1600) = true 
order by 2 limit 1)
union all
(select coordinates, 
st_distance(coordinates,to_geography('POINT(-73.986226 40.755702)'))::number(6,2) 
as distance_meters from v_osm_ny_shop_food_beverages 
where shop = 'alcohol' and 
st_dwithin(coordinates,st_makepoint(-73.986226, 40.755702),1600) = true 
order by 2 limit 1)
union all
(select coordinates, 
st_distance(coordinates,to_geography('POINT(-73.986226 40.755702)'))::number(6,2) 
as distance_meters from v_osm_ny_shop_food_beverages 
where shop = 'coffee' and 
st_dwithin(coordinates,st_makepoint(-73.986226, 40.755702),1600) = true 
order by 2 limit 1))
// Feed the linestring into an st_length calculation
select st_length(st_makeline(st_collect(coordinates),
to_geography('POINT(-73.986226 40.755702)')))
as length_meters from locations;