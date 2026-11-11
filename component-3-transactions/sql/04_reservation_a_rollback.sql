\set ON_ERROR_STOP on
\timing on
SET application_name='MIT8103_C3_RES_A_ROLLBACK';
SET statement_timeout='15s';
SET lock_timeout='8s';
SELECT pg_backend_pid() AS session_a_pid, clock_timestamp() AS session_a_started;
BEGIN;
INSERT INTO equipment_reservation
 (reservation_id,equipment_id,project_id,reserved_by,start_at,end_at,status,purpose)
OVERRIDING SYSTEM VALUE
VALUES (-300003,1,1,1,'2035-01-16 10:00+01','2035-01-16 12:00+01',
        'confirmed','Component 3 Session A rollback');
SELECT clock_timestamp() AS inserted_and_holding_transaction;
SELECT pg_sleep(5);
ROLLBACK;
SELECT clock_timestamp() AS session_a_rolled_back;

