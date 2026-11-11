\set ON_ERROR_STOP on
SET statement_timeout='15s';
SET lock_timeout='5s';
BEGIN;
INSERT INTO client (client_id,client_name,contact_name)
OVERRIDING SYSTEM VALUE
VALUES (-320001,'C3 Isolation Client','Isolation Tester');
INSERT INTO project
 (project_id,client_id,project_name,project_type,status,start_date,budget)
OVERRIDING SYSTEM VALUE
VALUES (-320001,-320001,'C3 Isolation Project','video','active','2035-01-01',100000.00);
COMMIT;
SELECT project_id,budget FROM project WHERE project_id=-320001;

