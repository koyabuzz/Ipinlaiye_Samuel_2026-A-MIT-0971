\set ON_ERROR_STOP on
\pset pager off
\echo 'Query 1: media assets awaiting review (top 50)'
SELECT p.project_id, p.project_name, c.client_name,
       count(*) AS review_asset_count, sum(ma.file_size_bytes) AS total_bytes,
       max(ma.created_at) AS latest_asset_at
FROM media_asset ma JOIN project p ON p.project_id = ma.project_id
JOIN client c ON c.client_id = p.client_id
WHERE ma.status = 'review'
  AND ma.created_at >= TIMESTAMPTZ '2026-01-01 00:00:00+01'
  AND ma.created_at < TIMESTAMPTZ '2026-04-01 00:00:00+01'
  AND p.status = 'active'
GROUP BY p.project_id, p.project_name, c.client_name
HAVING count(*) >= 3 ORDER BY total_bytes DESC LIMIT 50;

\echo 'Query 2: current staff project workload'
SELECT s.staff_id, s.first_name, s.last_name, s.employment_type,
       count(DISTINCT pa.project_id) AS active_project_count,
       count(*) AS active_role_count
FROM staff s JOIN project_assignment pa ON pa.staff_id = s.staff_id
JOIN project p ON p.project_id = pa.project_id
WHERE s.active = true AND p.status = 'active'
  AND pa.assigned_from <= DATE '2026-11-10'
  AND (pa.assigned_until IS NULL OR pa.assigned_until >= DATE '2026-11-10')
GROUP BY s.staff_id, s.first_name, s.last_name, s.employment_type
ORDER BY active_role_count DESC, s.last_name, s.first_name;

\echo 'Query 3: confirmed camera equipment schedule'
SELECT er.start_at, er.end_at, e.asset_tag, e.equipment_name, e.equipment_type,
       p.project_name, concat(s.first_name, ' ', s.last_name) AS reserved_by
FROM equipment_reservation er JOIN equipment e ON e.equipment_id = er.equipment_id
JOIN project p ON p.project_id = er.project_id
JOIN staff s ON s.staff_id = er.reserved_by
WHERE er.status IN ('confirmed', 'checked_out')
  AND er.start_at < TIMESTAMPTZ '2026-07-08 00:00:00+01'
  AND er.end_at > TIMESTAMPTZ '2026-07-01 00:00:00+01'
  AND e.equipment_type = 'camera'
ORDER BY er.start_at, e.asset_tag;

\echo 'Result row counts'
WITH q1 AS (
 SELECT p.project_id FROM media_asset ma JOIN project p ON p.project_id=ma.project_id
 JOIN client c ON c.client_id=p.client_id WHERE ma.status='review'
 AND ma.created_at>=TIMESTAMPTZ '2026-01-01 00:00:00+01'
 AND ma.created_at<TIMESTAMPTZ '2026-04-01 00:00:00+01' AND p.status='active'
 GROUP BY p.project_id,p.project_name,c.client_name HAVING count(*)>=3
), q2 AS (
 SELECT s.staff_id FROM staff s JOIN project_assignment pa ON pa.staff_id=s.staff_id
 JOIN project p ON p.project_id=pa.project_id WHERE s.active=true AND p.status='active'
 AND pa.assigned_from<=DATE '2026-11-10'
 AND (pa.assigned_until IS NULL OR pa.assigned_until>=DATE '2026-11-10')
 GROUP BY s.staff_id,s.first_name,s.last_name,s.employment_type
), q3 AS (
 SELECT er.reservation_id FROM equipment_reservation er
 JOIN equipment e ON e.equipment_id=er.equipment_id
 JOIN project p ON p.project_id=er.project_id JOIN staff s ON s.staff_id=er.reserved_by
 WHERE er.status IN ('confirmed','checked_out')
 AND er.start_at<TIMESTAMPTZ '2026-07-08 00:00:00+01'
 AND er.end_at>TIMESTAMPTZ '2026-07-01 00:00:00+01' AND e.equipment_type='camera'
)
SELECT (SELECT count(*) FROM q1) AS query_1_rows,
       (SELECT count(*) FROM q2) AS query_2_rows,
       (SELECT count(*) FROM q3) AS query_3_rows;

