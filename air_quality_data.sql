-- Creating the database
create database air_qual;
use air_qual;

create table air_data (
	country char(30),
    city char(30),
    aqi_value int,
    aqi_cat char(40),
    co_aqi_value int,
    co_aqi_cat char(40),
	ozone_aqi_val int,
    ozone_aqi_cat char(40),	
    NO2_aqi_val int,
	NO2_aqi_cat char(40),
	PM_aqi_val int,
    PM_aqi_cat char(40),
	lat float(7),
    lng float(7)
);
-- Viewing data after import
select * from air_data LIMIT 10;

-- Seeing if any city names appear multiple times
select distinct city, count(*) from air_data group by 1 order by 2 desc limit 10;


-- Finding cities that are likely duplicates
select distinct city, country, count(*) from air_data group by 1,2 order by 3 desc;

-- Removing duplicates method #1
delete from air_data
where lat in(
			select * from (
				select max(lat)
				from air_data
				group by city, country
				having count(*) > 1) as x
);

-- Removing duplicates method #2
delete from air_data
where lat not in(
select * from(
				select min(lat)
				from air_data
				group by city, country));

-- Finding the number rows with no country
select count(*) as empty_country from air_data where country = '' ;


select distinct country from air_data;


-- Fixing name spellings
update air_data set country = 'Vietnam' where country = 'Viet Nam';
update air_data set country = 'Ivory Coast' where country = "CÃ´te d'Ivoire";
-- Checking to make sure the changes have occured
select * from air_data where country = 'Vietnam';
select * from air_data where country = 'Ivory Coast';

-- EDA

-- Number of rows
SELECT COUNT(*) AS rows_num FROM air_data;

-- Distinct values for each category column
select distinct aqi_cat from air_data;
select distinct co_aqi_cat from air_data;
select distinct ozone_aqi_cat from air_data;
select distinct PM_aqi_cat from air_data;


-- Count for each category
select aqi_cat, count(*) from air_data group by 1 order by 2 desc;
select co_aqi_cat, count(*) from air_data group by 1 order by 2 desc;
select ozone_aqi_cat, count(*) from air_data group by 1 order by 2 desc;
select PM_aqi_cat, count(*) from air_data group by 1 order by 2 desc;


-- Percentage of cities in each category
SELECT aqi_cat, count(*), ROUND((COUNT(*) / (SELECT COUNT(*) FROM air_data)) * 100, 1) AS pct
FROM air_data GROUP BY 1 ORDER BY 3 DESC;
SELECT co_aqi_cat, count(*), ROUND((COUNT(*) / (SELECT COUNT(*) FROM air_data)) * 100, 1) AS pct
FROM air_data GROUP BY 1 ORDER BY 3 DESC;
SELECT ozone_aqi_cat, count(*), ROUND((COUNT(*) / (SELECT COUNT(*) FROM air_data)) * 100, 1) AS pct
FROM air_data GROUP BY 1 ORDER BY 3 DESC;
SELECT NO2_aqi_cat, count(*), ROUND((COUNT(*) / (SELECT COUNT(*) FROM air_data)) * 100, 1) AS pct
FROM air_data GROUP BY 1 ORDER BY 3 DESC;
SELECT PM_aqi_cat, count(*), ROUND((COUNT(*) / (SELECT COUNT(*) FROM air_data)) * 100, 1) AS pct
FROM air_data GROUP BY 1 ORDER BY 3 DESC;

-- 10 countries with the most cities in the dataset
select country, count(*) from air_data group by country order by 2 desc limit 11;

SELECT country, count(*), ROUND((COUNT(*) / (SELECT COUNT(*) FROM air_data)) * 100, 1) AS pct
FROM air_data GROUP BY 1 ORDER BY 3 DESC;

-- Top 10 cities with the worst air quality (more than 10 had scores of 500)
select city, country, avg(aqi_value) as city_aqi from air_data group by 1, 2 order by 3 desc limit 10;
-- Top 10 countries ranked by highest average score per city
select country, avg(aqi_value) as country_avg from air_data group by 1 order by 2 desc limit 10;
-- Top 10 countries ranked by highest average score per city for countries with more than 10 cities in the dataset
select country, avg(aqi_value) as big_country_avg, count(*) from air_data group by 1
having count(*) > 10 order by 2 desc limit 10;

-- Aggregations
-- Average, min, and max AQI scores
SELECT MIN(aqi_value) AS min_score, MAX(aqi_value) AS max_score, ROUND(AVG(aqi_value),1) AS avg_score
FROM air_data; 
SELECT MIN(co_aqi_value) AS co_min_score, MAX(co_aqi_value) AS co_max_score, ROUND(AVG(co_aqi_value),1) AS co_avg_score
FROM air_data; 
SELECT MIN(ozone_aqi_val) AS ozone_min_score, MAX(ozone_aqi_val) AS ozone_max_score, ROUND(AVG(ozone_aqi_val),1) AS ozone_avg_score
FROM air_data; 
SELECT MIN(NO2_aqi_val) AS NO2_min_score, MAX(NO2_aqi_val) AS NO2_max_score, ROUND(AVG(NO2_aqi_val),1) AS NO2_avg_score
FROM air_data; 
SELECT MIN(PM_aqi_val) AS PM_min_score, MAX(PM_aqi_val) AS PM_max_score, ROUND(AVG(PM_aqi_val),1) AS PM_avg_score
FROM air_data; 

