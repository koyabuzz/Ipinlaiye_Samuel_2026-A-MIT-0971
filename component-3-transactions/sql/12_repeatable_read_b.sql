\set ON_ERROR_STOP on
\timing on
SET application_name='MIT8103_C3_RR_B';
SET statement_timeout='10s';
SET lock_timeout='5s';
SELECT pg_backend_pid() AS rr_b_pid;
BEGIN;
UPDATE project SET budget=120000.00 WHERE project_id=-320001;
COMMIT;
SELECT budget AS value_committed_by_b FROM project WHERE project_id=-320001;

