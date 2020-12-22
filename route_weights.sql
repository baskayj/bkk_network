-- Now that we have the link list, we have to eliminate duplicate links by adding a "weight" column
-- It'll help in calculating the node degree, for example, since it's easy to sum up ones

-- DAYTIME--------------------------------------------------------------------------------------------------------------
CREATE TABLE route_links_daytime (route_1 VARCHAR(10),
                    route_2 VARCHAR(10));

COPY route_links_daytime(route_1,route_2)
FROM 'route_links_daytime.csv'
DELIMITER ','
CSV HEADER;

SELECT f.route_1,f.route_2,COUNT(*) AS weight INTO route_w_links_daytime FROM (SELECT DISTINCT * FROM route_links_daytime) f GROUP BY route_1,route_2;

DROP TABLE route_links_daytime;

-- NIGHTTIME------------------------------------------------------------------------------------------------------------
CREATE TABLE route_links_nighttime (route_1 VARCHAR(10),
                    route_2 VARCHAR(10));

COPY route_links_nighttime(route_1,route_2)
FROM 'route_links_nighttime.csv'
DELIMITER ','
CSV HEADER;

SELECT f.route_1,f.route_2,COUNT(*) AS weight INTO route_w_links_nighttime FROM (SELECT DISTINCT * FROM route_links_nighttime) f GROUP BY route_1,route_2;

DROP TABLE route_links_nighttime;