-- We can calculate the degree of each node
-- DAYTIME--------------------------------------------------------------------------------------------------------------
SELECT DISTINCT route_1, (SELECT SUM(weight) FROM route_w_links_daytime t2 WHERE t2.route_1=t1.route_1) AS degree
    INTO route_degree_daytime
    FROM route_w_links_daytime t1
    ORDER BY route_1;

-- We can turn this into a histogram by calculating p_k=N_k/N for each k
SELECT DISTINCT t1.degree, (SELECT count(t2.degree) FROM route_degree_daytime t2 WHERE t2.degree=t1.degree) AS pk
    INTO tmp
    FROM route_degree_daytime t1
    ORDER BY t1.degree;

SELECT degree, pk/(SELECT SUM(t2.pk) FROM tmp t2) AS pk
INTO route_degree_distr_daytime
FROM tmp;

DROP TABLE tmp;


-- The average degree:
-- SELECT AVG(t3.degree)
-- FROM (SELECT DISTINCT route_1, (SELECT SUM(weight) FROM route_w_links_daytime t2 WHERE t2.route_1=t1.route_1) AS degree
--    FROM route_w_links_daytime t1
--    ORDER BY route_1) t3;
-- RESULT: 55.77

-- NIGHTTIME------------------------------------------------------------------------------------------------------------
SELECT DISTINCT route_1, (SELECT SUM(weight) FROM route_w_links_nighttime t2 WHERE t2.route_1=t1.route_1) AS degree
    INTO route_degree_nighttime
    FROM route_w_links_nighttime t1
    ORDER BY route_1;

SELECT DISTINCT t1.degree, (SELECT count(t2.degree) FROM route_degree_nighttime t2 WHERE t2.degree=t1.degree) AS pk
    INTO tmp
    FROM route_degree_nighttime t1
    ORDER BY t1.degree;

SELECT degree, pk/(SELECT SUM(t2.pk) FROM tmp t2) AS pk
INTO route_degree_distr_nighttime
FROM tmp;

DROP TABLE tmp;

-- The average degree:
-- SELECT AVG(t3.degree)
-- FROM (SELECT DISTINCT route_1, (SELECT SUM(weight) FROM route_w_links_nighttime t2 WHERE t2.route_1=t1.route_1) AS degree
--    FROM route_w_links_nighttime t1
--    ORDER BY route_1) t3;
-- RESULT: 17.03