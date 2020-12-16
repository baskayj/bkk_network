-- Based on the relationship diagram we can see, that apart from the GPS coordinates there are no indirect connections between the routes and the stops
-- So first we have to join stops and shapes based on the common GPS coordinates
-- We can do this, because shapes contain series of GPS coords. that when drawn on a map shows where a given line is going.
-- After that the trips database contains a connection between shapes and routes, so we can join on that.
-- Finally some route-stop combinations appear more than once, so by using the distinct keyword we can eliminate them resulting in
-- roughly 16 thousand unique nodes.

SELECT DISTINCT  route_id,stop_id, parent_station, direction_id
                INTO routes_and_stops
                FROM trips
                INNER JOIN (SELECT stop_id, shape_id, parent_station
                            FROM stops
                            INNER JOIN shapes
                            ON stops.stop_lat=shapes.shape_pt_lat AND stops.stop_lon=shapes.shape_pt_lon) f
                ON trips.shape_id = f.shape_id;