-- Same as route_triangles

SELECT t1.stop_1,t1.stop_2,t1.stop_3,t2.stop_2 AS stop_4, COUNT(*) AS weight
INTO stop_triangles_daytime
FROM (SELECT f.stop_1,f.stop_2,g.stop_2 as stop_3
        FROM stop_w_links_daytime f
        JOIN stop_w_links_daytime g
        ON f.stop_2=g.stop_1
        WHERE f.stop_1!=g.stop_2) t1
JOIN stop_w_links_daytime t2
ON t1.stop_3 = t2.stop_1
WHERE t1.stop_1=t2.stop_2
GROUP BY t1.stop_1,t1.stop_2,t1.stop_3,t2.stop_2
ORDER BY  t1.stop_1;


-- GLOBAL CLUSTERING (possible triangles vs present triangles)
SELECT t3.c_1/t4.c_2 AS global_clustering FROM
    (SELECT t1.c_1,COUNT(t1.c_1) AS cc FROM
        (SELECT SUM(weight) AS c_1 FROM stop_triangles_daytime) t1
         GROUP BY t1.c_1) t3
JOIN
    (SELECT t2.c_2,COUNT(t2.c_2) AS cc FROM
        (SELECT SUM(degree*(degree-1)) AS c_2 FROM stop_degree_daytime) t2
         GROUP BY t2.c_2) t4
ON t3.cc = t4.cc;
-- GLOBAL CLUSTERING = 0.436

-- This bit scales with N^2 which means it's expected runtime is over 50 hours!
--SELECT t1.stop_1, t1.count/t2.count_max AS clustering
--INTO stop_clustering_daytime
--FROM    (SELECT DISTINCT stop_1, (SELECT SUM(weight)/2 FROM stop_triangles_daytime t2 WHERE t2.stop_1=t1.stop_1) AS count
--        FROM stop_triangles_daytime t1
--        ORDER BY stop_1) t1
--JOIN (SELECT stop_1,degree*(degree-1)*0.5 AS count_max FROM stop_degree_daytime) t2
--ON t1.stop_1=t2.stop_1;

--SELECT AVG(clustering) FROM stop_clustering_daytime;
-- AVG CLUSTERING = 0.715