EXPLAIN (ANALYZE, BUFFERS, SETTINGS)
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

