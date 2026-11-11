\set ON_ERROR_STOP on
SET statement_timeout='15s';
SET lock_timeout='5s';
BEGIN;
DELETE FROM equipment_reservation WHERE reservation_id=-300001;
DELETE FROM equipment_reservation WHERE reservation_id=-300002;
DELETE FROM equipment_reservation WHERE reservation_id=-300003;
DELETE FROM equipment_reservation WHERE reservation_id=-300004;
DELETE FROM project WHERE project_id=-320001;
DELETE FROM client WHERE client_id=-320001;
DELETE FROM client WHERE client_id=-310001;
DELETE FROM client WHERE client_id=-310002;
COMMIT;
SELECT 'client' AS object_type,client_id AS test_id FROM client
 WHERE client_id IN (-310001,-310002,-320001)
UNION ALL SELECT 'project',project_id FROM project WHERE project_id=-320001
UNION ALL SELECT 'reservation',reservation_id FROM equipment_reservation
 WHERE reservation_id IN (-300001,-300002,-300003,-300004);
SELECT 'client' AS table_name,count(*) AS rows FROM client
UNION ALL SELECT 'project',count(*) FROM project
UNION ALL SELECT 'staff',count(*) FROM staff
UNION ALL SELECT 'project_assignment',count(*) FROM project_assignment
UNION ALL SELECT 'media_asset',count(*) FROM media_asset
UNION ALL SELECT 'equipment',count(*) FROM equipment
UNION ALL SELECT 'equipment_reservation',count(*) FROM equipment_reservation;
SELECT indexname FROM pg_indexes WHERE schemaname='public'
AND indexname IN ('ix_media_asset_review_created_project',
                  'ix_assignment_staff_dates_project',
                  'ix_reservation_blocking_start') ORDER BY indexname;
SELECT conname FROM pg_constraint
WHERE conrelid='equipment_reservation'::regclass
AND conname IN ('ex_reservation_no_active_overlap','fk_reservation_equipment',
                'fk_reservation_project','fk_reservation_staff') ORDER BY conname;
SELECT tgname FROM pg_trigger WHERE tgrelid='equipment_reservation'::regclass
AND tgname='trg_reservation_staff_active' AND NOT tgisinternal;

