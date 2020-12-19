-- To speed up the link finding we can order the dataset by route ID, thus we only really have to ask, if it changes, we don't have to check for equality
-- Here we can't really filter, because all routes have multiple stops, connecting them together.
-- DAYTIME

SELECT *
FROM routes_and_stops_daytime
Order by route_id;