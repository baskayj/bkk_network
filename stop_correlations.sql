SELECT t2.stop_1,t2.stop_2, t2.degree as degree_1, t3.degree as degree_2
INTO stop_link_degree_daytime
FROM (SELECT t1.stop_1,t1.stop_2,degree FROM stop_w_links_daytime t1
        JOIN stop_degree_daytime
        ON t1.stop_1=stop_degree_daytime.stop_1) t2
JOIN stop_degree_daytime t3
ON t2.stop_2=t3.stop_1
ORDER BY stop_1;

SELECT DISTINCT t1.degree_1 AS k, (SELECT SUM(t2.degree_2) FROM stop_link_degree_daytime t2 WHERE t2.stop_1=t1.stop_1)/t1.degree_1 AS knn
    INTO stop_deg_corr_daytime
    FROM stop_link_degree_daytime t1
    ORDER BY t1.degree_1;

SELECT AVG(degree*degree)/AVG(degree) FROM stop_degree_daytime;
-- RESULT: 105.30(29308323563893)