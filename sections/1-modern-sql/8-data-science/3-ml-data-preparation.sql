-- ML Data Preparation: weather.csv
use test.public;

-- upload WEATHER.CSV file into new WEATHER table, w/ timestamp_ntz, number, number
-- show below as Line chart --> add WIND as series, see seasonality on TEMP
select ts, temp, wind
from weather
order by ts;

-- check if proper timeserie (for forecast/anomaly detection) --> must return nothing
select ts, count(*) as c
from weather
group by ts
having c > 1;

select count(*)
from weather;

-- need ~70%+ as train data (1095/497 entries), for supervised algs
select (ts < '2021-01-01') as train, count(*)
from weather
group by train;

select min(temp), max(temp), avg(temp), mode(temp), median(temp)
from weather;

-- decide for outliers (5/1587 entries), for anomaly detection 
select (temp > 85 or temp < 0) as extreme, count(*)
from weather
group by extreme;

select min(wind), max(wind), avg(wind), mode(wind), median(wind)
from weather;

-- decide for bad weather (242/1350 vals), for classification
select (temp > 80 and wind < 10) or (temp < 60 and wind > 10) as bad, count(*)
from weather
group by bad;

-- are temp and wind correlated?
select corr(temp, wind)
from weather;

-- final view
select ts, -- timestamp
    temp, -- main measure
    wind, -- use as exogenous var
    (temp > 80 and wind < 10) or (temp < 60 and wind > 10) as bad, -- for classification
    (temp > 85 or temp < 0) as extreme, -- for outliers (anomaly detection)
    (ts < '2021-01-01') as train -- for train/test datasets (forecast/contribution explorer)
from weather;

create or replace view weather_view as
select ts, temp, wind,
    (temp > 80 and wind < 10) or (temp < 60 and wind > 10) as bad,
    (temp > 85 or temp < 0) as extreme,
    (ts < '2021-01-01') as train
from weather;
table weather_view;
