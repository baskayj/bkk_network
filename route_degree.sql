-- We can calculate the degree of each node
-- DAYTIME
SELECT DISTINCT route_1, (SELECT SUM(weight) FROM route_w_links_daytime t2 WHERE t2.route_1=t1.route_1) AS degree
    INTO route_degree_daytime
    FROM route_w_links_daytime t1
    ORDER BY route_1;
-- Feeding the result to plt.hist we shall obtain the degree distribution

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

-- The average degree:
-- SELECT AVG(t3.degree)
-- FROM (SELECT DISTINCT route_1, (SELECT SUM(weight) FROM route_w_links_nighttime t2 WHERE t2.route_1=t1.route_1) AS degree
--    FROM route_w_links_nighttime t1
--    ORDER BY route_1) t3;
-- RESULT: 17.03