EXPLAIN (ANALYZE, BUFFERS, SETTINGS)
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

