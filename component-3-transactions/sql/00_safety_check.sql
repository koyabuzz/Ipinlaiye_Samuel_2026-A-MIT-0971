\set ON_ERROR_STOP on
SELECT current_database() AS database_name,
       current_setting('server_version') AS server_version;
SELECT 'client' AS table_name, count(*) AS rows FROM client
UNION ALL SELECT 'project', count(*) FROM project
UNION ALL SELECT 'staff', count(*) FROM staff
UNION ALL SELECT 'project_assignment', count(*) FROM project_assignment
UNION ALL SELECT 'media_asset', count(*) FROM media_asset
UNION ALL SELECT 'equipment', count(*) FROM equipment
UNION ALL SELECT 'equipment_reservation', count(*) FROM equipment_reservation;
SELECT project_id, status FROM project WHERE project_id=1;
SELECT staff_id, active FROM staff WHERE staff_id=1;
SELECT equipment_id, active FROM equipment WHERE equipment_id=1;
SELECT 'client' AS object_type, client_id AS test_id FROM client
 WHERE client_id IN (-310001,-310002,-320001)
UNION ALL SELECT 'project', project_id FROM project WHERE project_id=-320001
UNION ALL SELECT 'reservation', reservation_id FROM equipment_reservation
 WHERE reservation_id IN (-300001,-300002,-300003,-300004);

