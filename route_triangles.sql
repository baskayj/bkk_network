-- To count triangles, first we have to form them
-- For this we first get the second neighbours (except the initail node itself)
-- Then the third neighbeours, with the condition that they are the initial node, thus completing triangles
-- Finally we add a new column for easier summation

-- DAYTIME--------------------------------------------------------------------------------------------------------------
SELECT t1.route_1,t1.route_2,t1.route_3,t2.route_2 AS route_4, COUNT(*) AS weight
INTO route_triangles_daytime
FROM (SELECT f.route_1,f.route_2,g.route_2 as route_3
        FROM route_w_links_daytime f
        JOIN route_w_links_daytime g
        ON f.route_2=g.route_1
        WHERE f.route_1!=g.route_2) t1
JOIN route_w_links_daytime t2
ON t1.route_3 = t2.route_1
WHERE t1.route_1=t2.route_2
GROUP BY t1.route_1,t1.route_2,t1.route_3,t2.route_2
ORDER BY  t1.route_1;


-- GLOBAL CLUSTERING (possible triangles vs present triangles)
SELECT t3.c_1/t4.c_2 AS global_clustering FROM
    (SELECT t1.c_1,COUNT(t1.c_1) AS cc FROM
        (SELECT SUM(weight) AS c_1 FROM route_triangles_daytime) t1
         GROUP BY t1.c_1) t3
JOIN
    (SELECT t2.c_2,COUNT(t2.c_2) AS cc FROM
        (SELECT SUM(degree*(degree-1)) AS c_2 FROM route_degree_daytime) t2
         GROUP BY t2.c_2) t4
ON t3.cc = t4.cc;
-- GLOBAL CLUSTERING = 0.466


-- We can also count how many triangles each node has, and divide by the possible number of triangles (0.5*k*(k-1))
-- In the count there is a division by two, because in the triangles table every triangle is present twice. (a-b-c-a and a-c-b-a)
SELECT t1.route_1, t1.count/t2.count_max AS clustering
INTO route_clustering_daytime
FROM    (SELECT DISTINCT route_1, (SELECT SUM(weight)/2 FROM route_triangles_daytime t2 WHERE t2.route_1=t1.route_1) AS count
        FROM route_triangles_daytime t1
        ORDER BY route_1) t1
JOIN (SELECT route_1,degree*(degree-1)*0.5 AS count_max FROM route_degree_daytime) t2
ON t1.route_1=t2.route_1;

SELECT AVG(clustering) FROM route_clustering_daytime;
-- AVG CLUSTERING = 0.57

-- NIGHTTIME------------------------------------------------------------------------------------------------------------
SELECT t1.route_1,t1.route_2,t1.route_3,t2.route_2 AS route_4, COUNT(*) AS weight
INTO route_triangles_nighttime
FROM (SELECT f.route_1,f.route_2,g.route_2 as route_3
        FROM route_w_links_nighttime f
        JOIN route_w_links_nighttime g
        ON f.route_2=g.route_1
        WHERE f.route_1!=g.route_2) t1
JOIN route_w_links_nighttime t2
ON t1.route_3 = t2.route_1
WHERE t1.route_1=t2.route_2
GROUP BY t1.route_1,t1.route_2,t1.route_3,t2.route_2
ORDER BY  t1.route_1;


SELECT t3.c_1/t4.c_2 AS global_clustering FROM
    (SELECT t1.c_1,COUNT(t1.c_1) AS cc FROM
        (SELECT SUM(weight) AS c_1 FROM route_triangles_nighttime) t1
         GROUP BY t1.c_1) t3
JOIN
    (SELECT t2.c_2,COUNT(t2.c_2) AS cc FROM
        (SELECT SUM(degree*(degree-1)) AS c_2 FROM route_degree_nighttime) t2
         GROUP BY t2.c_2) t4
ON t3.cc = t4.cc;
-- GLOBAL CLUSTERING = 0.652


SELECT t1.route_1, t1.count/t2.count_max AS clustering
INTO route_clustering_nighttime
FROM    (SELECT DISTINCT route_1, (SELECT SUM(weight)/2 FROM route_triangles_nighttime t2 WHERE t2.route_1=t1.route_1) AS count
        FROM route_triangles_nighttime t1
        ORDER BY route_1) t1
JOIN (SELECT route_1,degree*(degree-1)*0.5 AS count_max FROM route_degree_nighttime) t2
ON t1.route_1=t2.route_1;

SELECT AVG(clustering) FROM route_clustering_nighttime;
-- AVG CLUSTERING = 0.715



