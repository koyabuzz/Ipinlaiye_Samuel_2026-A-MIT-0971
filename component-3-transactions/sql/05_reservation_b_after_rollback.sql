\set ON_ERROR_STOP on
\timing on
SET application_name='MIT8103_C3_RES_B_SUCCEEDS';
SET statement_timeout='15s';
SET lock_timeout='8s';
SELECT pg_backend_pid() AS session_b_pid, clock_timestamp() AS session_b_started;
BEGIN;
SELECT clock_timestamp() AS blocked_insert_attempted;
INSERT INTO equipment_reservation
 (reservation_id,equipment_id,project_id,reserved_by,start_at,end_at,status,purpose)
OVERRIDING SYSTEM VALUE
VALUES (-300004,1,1,1,'2035-01-16 11:00+01','2035-01-16 13:00+01',
        'confirmed','Component 3 Session B succeeds after rollback');
SELECT reservation_id,status FROM equipment_reservation WHERE reservation_id=-300004;
SELECT clock_timestamp() AS insert_completed_after_a_rollback;
ROLLBACK;
SELECT count(*) AS session_b_record_after_rollback
FROM equipment_reservation WHERE reservation_id=-300004;

