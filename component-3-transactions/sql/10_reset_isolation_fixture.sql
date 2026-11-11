\set ON_ERROR_STOP on
SET statement_timeout='10s';
SET lock_timeout='5s';
BEGIN;
UPDATE project SET budget=100000.00 WHERE project_id=-320001;
COMMIT;
SELECT project_id,budget FROM project WHERE project_id=-320001;

