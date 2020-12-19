-- To speed up the link finding we can order the dataset by stop ID, thus we only really have to ask, if it changes, we don't have to check for equality
-- In the same query we can also filter out any stops that only have a single route, because these stops make no connections between the routes

SELECT *
FROM routes_and_stops_daytime
WHERE stop_name IN (
    SELECT stop_name
    FROM routes_and_stops_daytime
    GROUP BY stop_name
    HAVING COUNT(stop_name) > 1
    )
Order by stop_name;

SELECT *
FROM routes_and_stops_nighttime
WHERE stop_name IN (
    SELECT stop_name
    FROM routes_and_stops_nighttime
    GROUP BY stop_name
    HAVING COUNT(stop_name) > 1
    )
Order by stop_name;