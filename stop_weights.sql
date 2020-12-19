-- Now that we have the link list, we have to eliminate duplicate links by adding a "weight" column
-- It'll help in calculating the node degree, for example, since it's easy to sum up ones

CREATE TABLE stop_links_daytime (stop_1 VARCHAR(100),
                    stop_2 VARCHAR(100));

COPY stop_links_daytime(stop_1,stop_2)
FROM 'stop_links_daytime.csv'
DELIMITER ','
CSV HEADER;

SELECT f.stop_1,f.stop_2,COUNT(*) AS weight INTO stop_w_links_daytime FROM (SELECT DISTINCT * FROM stop_links_daytime) f GROUP BY stop_1,stop_2;

DROP TABLE stop_links_daytime;