CREATE TABLE agency (agency_id VARCHAR(10),
                    agency_name VARCHAR(100),
                    agency_url TEXT,
                    agency_timezone VARCHAR(100),
                    agency_lang VARCHAR(10),
                    agency_phone VARCHAR(15),
                    PRIMARY KEY (agency_id));

COPY agency(agency_id,agency_name,agency_url,agency_timezone,agency_lang,agency_phone)
FROM 'agency.txt'
DELIMITER ','
CSV HEADER;

-- We'll ignore calendar_dates.txt and stop_times.txt as we don't need temporal data

CREATE TABLE feed_info (feed_id VARCHAR(10),
                        feed_publisher_name VARCHAR(100),
                        feed_publisher_url TEXT,
                        feed_lang VARCHAR(10),
                        feed_start_date NUMERIC(8,0),
                        feed_end_date NUMERIC(8,0),
                        feed_version VARCHAR(100),
                        feed_ext_version VARCHAR(100),
                        PRIMARY KEY (feed_id));

COPY feed_info(feed_id,feed_publisher_name,feed_publisher_url,feed_lang,feed_start_date,feed_end_date,feed_version,feed_ext_version)
FROM 'feed_info.txt'
DELIMITER ','
CSV HEADER;


CREATE TABLE stops  (stop_id VARCHAR(10),
                    stop_name VARCHAR(100),
                    stop_lat NUMERIC(8,6),
                    stop_lon NUMERIC(8,6),
                    stop_code VARCHAR(10),
                    location_type INT,
                    parent_station VARCHAR(10),
                    wheelchair_boarding INT,
                    stop_direction BIGINT,
                    PRIMARY KEY (stop_id),
                    FOREIGN KEY  (parent_station) REFERENCES stops(stop_id),
                    FOREIGN KEY  (stop_code) REFERENCES stops(stop_id));

COPY stops(stop_id,stop_name,stop_lat,stop_lon,stop_code,location_type,parent_station,wheelchair_boarding,stop_direction)
FROM 'stops.txt'
DELIMITER ','
CSV HEADER;

--Contains foreign keys relating to stops, has to be created later
CREATE TABLE pathways  (pathway_id VARCHAR(20),
                        pathway_mode INT,
                        is_bidirectional BOOLEAN,
                        from_stop_id VARCHAR(10),
                        to_stop_id VARCHAR(10),
                        traversal_time BIGINT,
                        PRIMARY KEY (pathway_id),
                        FOREIGN KEY (from_stop_id) REFERENCES stops(stop_id),
                        FOREIGN KEY (to_stop_id) REFERENCES stops(stop_id));

COPY pathways(pathway_id,pathway_mode,is_bidirectional,from_stop_id,to_stop_id,traversal_time)
FROM 'pathways.txt'
DELIMITER ','
CSV HEADER;

CREATE TABLE routes    (agency_id VARCHAR(10),
                        route_id VARCHAR(10),
                        route_short_name VARCHAR(4),
                        route_long_name VARCHAR(50),
                        route_type INT, -- 3:Bus;0:Tram;800:Trolleybus;1:Metro;109:HéV;4:Ship
                        route_desc TEXT,
                        route_color VARCHAR(6), -- We don't need this, hence we won't convert it to int
                        route_text_color VARCHAR(6), -- Same as above
                        route_sort_order INT,
                        route_icon_display_text TEXT,
                        PRIMARY KEY (route_id),
                        FOREIGN KEY (agency_id) REFERENCES agency(agency_id));

COPY routes(agency_id,route_id,route_short_name,route_long_name,route_type,route_desc,route_color,route_text_color,route_sort_order,route_icon_display_text)
FROM 'routes.txt'
DELIMITER ','
CSV HEADER;

CREATE TABLE shapes    (shape_id VARCHAR(10),
                        shape_pt_sequence BIGINT,
                        shape_pt_lat NUMERIC(8,6),
                        shape_pt_lon NUMERIC(8,6),
                        shape_dist_traveled NUMERIC(6,1));

COPY shapes(shape_id,shape_pt_sequence,shape_pt_lat,shape_pt_lon,shape_dist_traveled)
FROM 'shapes.txt'
DELIMITER ','
CSV HEADER;

--Contains foreign keys relating to shape, has to be created later
CREATE TABLE trips (route_id VARCHAR(10),
                    trip_id VARCHAR(50),
                    service_id VARCHAR(50),
                    trip_headsign TEXT,
                    direction_id SMALLINT, -- 0:To;1:From
                    block_id VARCHAR(50),
                    shape_id VARCHAR(10),
                    wheelchair_accessible SMALLINT,
                    bikes_allowed SMALLINT,
                    boarding_door SMALLINT,
                    PRIMARY KEY (trip_id),
                    FOREIGN KEY (route_id) REFERENCES routes(route_id));

COPY trips(route_id,trip_id,service_id,trip_headsign,direction_id,block_id,shape_id,wheelchair_accessible,bikes_allowed,boarding_door)
FROM 'trips.txt'
DELIMITER ','
CSV HEADER;