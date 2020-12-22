-- NIGHTTIME------------------------------------------------------------------------------------------------------------
-- We can obtain the degree of the nodes at the end of each link
SELECT t2.route_1,t2.route_2, t2.degree as degree_1, t3.degree as degree_2
INTO route_link_degree_nighttime
FROM (SELECT t1.route_1,t1.route_2,degree FROM route_w_links_nighttime t1
        JOIN route_degree_nighttime
        ON t1.route_1=route_degree_nighttime.route_1) t2
JOIN route_degree_nighttime t3
ON t2.route_2=t3.route_1
ORDER BY route_1;
-- Then we have to sum the degree at one end, and divide by the degree at the other end to obtain the degree correlation function. (As a func of k)
SELECT DISTINCT t1.degree_1 AS k, (SELECT SUM(t2.degree_2) FROM route_link_degree_nighttime t2 WHERE t2.route_1=t1.route_1)/t1.degree_1 AS knn
    INTO route_deg_corr_nighttime
    FROM route_link_degree_nighttime t1
    ORDER BY t1.degree_1;

-- For a neutral network the degree correlation function is a constant, with the value avg(k^2)/avg(k)
SELECT AVG(degree*degree)/AVG(degree) FROM route_degree_nighttime;
-- RESULT: 20.19(27710843373494)

-- DAYTIME--------------------------------------------------------------------------------------------------------------
SELECT t2.route_1,t2.route_2, t2.degree as degree_1, t3.degree as degree_2
INTO route_link_degree_daytime
FROM (SELECT t1.route_1,t1.route_2,degree FROM route_w_links_daytime t1
        JOIN route_degree_daytime
        ON t1.route_1=route_degree_daytime.route_1) t2
JOIN route_degree_daytime t3
ON t2.route_2=t3.route_1
ORDER BY route_1;

SELECT DISTINCT t1.degree_1 AS k, (SELECT SUM(t2.degree_2) FROM route_link_degree_daytime t2 WHERE t2.route_1=t1.route_1)/t1.degree_1 AS knn
    INTO route_deg_corr_daytime
    FROM route_link_degree_daytime t1
    ORDER BY t1.degree_1;

SELECT AVG(degree*degree)/AVG(degree) FROM route_degree_daytime;
-- RESULT: 67.46(16243995084348)