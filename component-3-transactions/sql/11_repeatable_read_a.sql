\set ON_ERROR_STOP on
\timing on
SET application_name='MIT8103_C3_RR_A';
SET statement_timeout='15s';
SET lock_timeout='5s';
SELECT pg_backend_pid() AS rr_a_pid;
BEGIN ISOLATION LEVEL REPEATABLE READ;
SELECT budget AS first_read FROM project WHERE project_id=-320001;
SELECT pg_sleep(4);
SELECT budget AS second_read_inside_same_snapshot FROM project WHERE project_id=-320001;
COMMIT;
SELECT budget AS read_after_a_commit FROM project WHERE project_id=-320001;

