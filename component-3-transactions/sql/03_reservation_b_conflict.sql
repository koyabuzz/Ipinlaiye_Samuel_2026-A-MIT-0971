\set VERBOSITY verbose
\timing on
SET application_name='MIT8103_C3_RES_B_CONFLICT';
SET statement_timeout='15s';
SET lock_timeout='8s';
SELECT pg_backend_pid() AS session_b_pid, clock_timestamp() AS session_b_started;
BEGIN;
SELECT clock_timestamp() AS conflicting_insert_attempted;
INSERT INTO equipment_reservation
 (reservation_id,equipment_id,project_id,reserved_by,start_at,end_at,status,purpose)
OVERRIDING SYSTEM VALUE
VALUES (-300002,1,1,1,'2035-01-15 11:00+01','2035-01-15 13:00+01',
        'confirmed','Component 3 Session B conflict');
SELECT clock_timestamp() AS unexpected_insert_success;
ROLLBACK;
SELECT clock_timestamp() AS session_b_rolled_back;

