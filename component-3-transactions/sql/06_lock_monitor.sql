\set ON_ERROR_STOP on
SET application_name='MIT8103_C3_MONITOR';
SET statement_timeout='10s';
\echo 'Activity and blockers'
SELECT pid,application_name,state,wait_event_type,wait_event,
       pg_blocking_pids(pid) AS blocking_pids,xact_start,query_start,query
FROM pg_stat_activity
WHERE datname='mit8103_media_portfolio'
  AND application_name LIKE 'MIT8103_C3_RES_%'
ORDER BY pid;
\echo 'Locks for experiment sessions'
SELECT a.pid,a.application_name,l.locktype,l.mode,l.granted,
       l.relation::regclass AS relation,l.transactionid,l.virtualxid
FROM pg_locks l JOIN pg_stat_activity a ON a.pid=l.pid
WHERE a.application_name LIKE 'MIT8103_C3_RES_%'
ORDER BY a.pid,l.granted,l.locktype,l.mode;

