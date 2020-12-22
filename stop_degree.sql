-- We can calculate the degree of each node
SELECT DISTINCT stop_1, (SELECT SUM(weight) FROM stop_w_links_daytime t2 WHERE t2.stop_1=t1.stop_1) AS degree
    INTO stop_degree_daytime
    FROM stop_w_links_daytime t1
    ORDER BY stop_1;

SELECT DISTINCT t1.degree, (SELECT count(t2.degree) FROM stop_degree_daytime t2 WHERE t2.degree=t1.degree) AS pk
    INTO tmp
    FROM stop_degree_daytime t1
    ORDER BY t1.degree;

SELECT degree, pk/(SELECT SUM(t2.pk) FROM tmp t2) AS pk
INTO stop_degree_distr_daytime
FROM tmp;

DROP TABLE tmp;


-- The average degree:
--SELECT AVG(t3.degree)
--FROM (SELECT DISTINCT stop_1, (SELECT SUM(weight) FROM stop_w_links t2 WHERE t2.stop_1=t1.stop_1) AS degree
--    FROM stop_w_links t1
--    ORDER BY stop_1) t3;
-- RESULT: 170.76