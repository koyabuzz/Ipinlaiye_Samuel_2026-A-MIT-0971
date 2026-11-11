\set ON_ERROR_STOP on
SELECT current_database() AS database_name,
       current_setting('server_version') AS server_version;
SELECT
    (SELECT count(*) FROM client) AS client,
    (SELECT count(*) FROM project) AS project,
    (SELECT count(*) FROM staff) AS staff,
    (SELECT count(*) FROM project_assignment) AS project_assignment,
    (SELECT count(*) FROM media_asset) AS media_asset,
    (SELECT count(*) FROM equipment) AS equipment,
    (SELECT count(*) FROM equipment_reservation) AS equipment_reservation;
DO $$
BEGIN
    IF (SELECT count(*) FROM client) <> 0
       OR (SELECT count(*) FROM project) <> 0
       OR (SELECT count(*) FROM staff) <> 0
       OR (SELECT count(*) FROM project_assignment) <> 0
       OR (SELECT count(*) FROM media_asset) <> 0
       OR (SELECT count(*) FROM equipment) <> 0
       OR (SELECT count(*) FROM equipment_reservation) <> 0 THEN
        RAISE EXCEPTION 'Safety stop: at least one application table is not empty';
    END IF;
END;
$$;

