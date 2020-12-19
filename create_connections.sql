-- Based on the relationship diagram we can see, that apart from the GPS coordinates there are no indirect connections between the routes and the stops
-- So first we have to join stops and shapes based on the common GPS coordinates
-- We can do this, because shapes contain series of GPS coords. that when drawn on a map shows where a given line is going.
-- After that the trips database contains a connection between shapes and routes, so we can join on that.
-- Finally some route-stop combinations appear more than once, so by using the distinct keyword we can eliminate them

SELECT DISTINCT  route_id,stop_id, stop_name, parent_station, direction_id
                INTO tmp_table
                FROM trips
                INNER JOIN (SELECT stop_id, shape_id, stop_name, parent_station
                            FROM stops
                            INNER JOIN shapes
                            ON stops.stop_lat=shapes.shape_pt_lat AND stops.stop_lon=shapes.shape_pt_lon) f
                ON trips.shape_id = f.shape_id;

-- Now for every station that has a parent, we set the station's id to be the parent
UPDATE tmp_table SET stop_id=parent_station WHERE parent_station IS NOT NULL;
-- We can now drop the parent station column
ALTER TABLE tmp_table
DROP COLUMN parent_station;

-- Now we have to deal with stations that share a name, but doesn't share ID in any way.
-- Example:
SELECT * FROM tmp_table WHERE stop_name = 'Mexikói út';
-- The easy fix is stopping to use the stop_id to identify stops and instead use their names
-- However there is directionality in stops. Oddly enough only a small fraction of stops exist in one direction and not in the other
SELECT COUNT(*) FROM tmp_table;
-- RESULT: 16658
ALTER TABLE tmp_table
DROP COLUMN direction_id;
SELECT COUNT(*) FROM (SELECT DISTINCT * FROM tmp_table) f;
-- RESULT: 15692
-- Thus we only commit a minor oversight by ignoring directionality. (The most important hubs are bi-directional, anyway.)

SELECT DISTINCT route_id,stop_name INTO routes_and_stops FROM tmp_table;

DROP TABLE tmp_table;

-- We can also filter out the Night-Time buses. Mainly because they seem to have high importance,
-- But as far as practical connections go, waiting 5-6 hours might not be as valuable as waiting 5 minutes...
SELECT g.route_id,g.stop_name
INTO routes_and_stops_daytime
FROM routes_and_stops g
INNER JOIN (SELECT * FROM routes WHERE route_color!='1E1E1E') f
ON g.route_id = f.route_id;

-- And for the "Night-time" network:
SELECT g.route_id,g.stop_name
INTO routes_and_stops_nighttime
FROM routes_and_stops g
INNER JOIN (SELECT * FROM routes WHERE route_color='1E1E1E') f
ON g.route_id = f.route_id;

DROP TABLE routes_and_stops;