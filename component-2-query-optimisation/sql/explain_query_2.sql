EXPLAIN (ANALYZE, BUFFERS, SETTINGS)
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

