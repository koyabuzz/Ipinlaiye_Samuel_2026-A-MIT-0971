\set ON_ERROR_STOP on
\timing on
SET statement_timeout='15s';
SET lock_timeout='5s';
SET application_name='MIT8103_C3_TX_DEMO';

\echo 'ROLLBACK demonstration'
BEGIN;
INSERT INTO client (client_id,client_name,contact_name)
OVERRIDING SYSTEM VALUE
VALUES (-310001,'C3 Rollback Test','Transaction Tester');
SELECT client_id,client_name FROM client WHERE client_id=-310001;
ROLLBACK;
SELECT count(*) AS rollback_record_after_rollback FROM client WHERE client_id=-310001;

\echo 'COMMIT demonstration'
BEGIN;
INSERT INTO client (client_id,client_name,contact_name)
OVERRIDING SYSTEM VALUE
VALUES (-310002,'C3 Commit Test','Transaction Tester');
COMMIT;
SELECT client_id,client_name FROM client WHERE client_id=-310002;

\echo 'Targeted cleanup of committed demonstration record'
BEGIN;
DELETE FROM client WHERE client_id=-310002;
COMMIT;
SELECT count(*) AS commit_record_after_cleanup FROM client WHERE client_id=-310002;

