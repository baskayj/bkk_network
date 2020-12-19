-- We can calculate the degree of each node
SELECT DISTINCT stop_1, (SELECT SUM(weight) FROM stop_w_links_daytime t2 WHERE t2.stop_1=t1.stop_1) AS degree
    INTO stop_degree_daytime
    FROM stop_w_links_daytime t1
    ORDER BY stop_1;
-- For this case the calculation was especially slow it took over 15 mins
-- Feeding the result to plt.hist we shall obtain the degree distribution

-- The average degree:
--SELECT AVG(t3.degree)
--FROM (SELECT DISTINCT stop_1, (SELECT SUM(weight) FROM stop_w_links t2 WHERE t2.stop_1=t1.stop_1) AS degree
--    FROM stop_w_links t1
--    ORDER BY stop_1) t3;
-- RESULT: 170.76