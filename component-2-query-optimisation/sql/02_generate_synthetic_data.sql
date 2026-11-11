\set ON_ERROR_STOP on
\timing on
BEGIN;
DO $$
BEGIN
    IF (SELECT count(*) FROM client) <> 0
       OR (SELECT count(*) FROM project) <> 0
       OR (SELECT count(*) FROM staff) <> 0
       OR (SELECT count(*) FROM project_assignment) <> 0
       OR (SELECT count(*) FROM media_asset) <> 0
       OR (SELECT count(*) FROM equipment) <> 0
       OR (SELECT count(*) FROM equipment_reservation) <> 0 THEN
        RAISE EXCEPTION 'Safety stop: synthetic data requires seven empty tables';
    END IF;
END;
$$;

INSERT INTO client (client_id, client_name, contact_name, email, phone, billing_address, created_at)
OVERRIDING SYSTEM VALUE
SELECT g, format('Client %s', lpad(g::text, 4, '0')), format('Contact %s', g),
       format('contact%s@example.test', g), format('+234-800-%07s', g),
       format('%s Production Avenue, Lagos', g),
       TIMESTAMPTZ '2024-01-01 09:00:00+01' + (g % 730) * INTERVAL '1 day'
FROM generate_series(1, 500) AS gs(g);

INSERT INTO staff (staff_id, first_name, last_name, email, phone, job_title,
                   employment_type, hire_date, active)
OVERRIDING SYSTEM VALUE
SELECT g, format('Staff%s', g), format('Surname%s', g),
       format('staff%s@example.test', g), format('+234-801-%07s', g),
       (ARRAY['Producer', 'Director', 'Editor', 'Camera Operator', 'Sound Engineer'])[((g - 1) % 5) + 1],
       CASE WHEN g % 4 = 0 THEN 'freelancer' ELSE 'employee' END,
       DATE '2020-01-01' + (g % 1825), g <= 900
FROM generate_series(1, 1000) AS gs(g);

INSERT INTO project (project_id, client_id, project_name, description, project_type,
                     status, start_date, end_date, budget, created_at)
OVERRIDING SYSTEM VALUE
SELECT g, ((g - 1) % 500) + 1,
       format('Production Project %s', lpad(g::text, 5, '0')),
       format('Deterministic synthetic project %s for query experiments', g),
       (ARRAY['video', 'audio', 'photography', 'animation', 'other'])[((g - 1) % 5) + 1],
       CASE WHEN g % 10 < 4 THEN 'active' WHEN g % 10 < 6 THEN 'completed'
            WHEN g % 10 = 6 THEN 'on_hold' WHEN g % 10 = 7 THEN 'cancelled'
            ELSE 'planned' END,
       DATE '2025-01-01' + (g % 365),
       CASE WHEN g % 10 IN (4, 5, 7)
            THEN DATE '2025-01-01' + (g % 365) + 120 ELSE NULL END,
       (25000 + (g % 200) * 1250)::numeric(14, 2),
       TIMESTAMPTZ '2024-06-01 08:00:00+01' + (g % 550) * INTERVAL '1 day'
FROM generate_series(1, 10000) AS gs(g);

INSERT INTO equipment (equipment_id, asset_tag, equipment_name, equipment_type,
                       manufacturer, model, serial_number, condition, active)
OVERRIDING SYSTEM VALUE
SELECT g, format('EQ-%s', lpad(g::text, 6, '0')), format('Equipment Item %s', g),
       (ARRAY['camera', 'lens', 'microphone', 'lighting'])[((g - 1) % 4) + 1],
       format('Maker %s', ((g - 1) % 20) + 1),
       format('Model %s', ((g - 1) % 100) + 1), format('SN%08s', g),
       CASE WHEN g % 50 = 0 THEN 'repair' WHEN g % 25 = 0 THEN 'fair' ELSE 'good' END,
       g % 50 <> 0
FROM generate_series(1, 5000) AS gs(g);

INSERT INTO project_assignment (assignment_id, project_id, staff_id, role_name,
                                assigned_from, assigned_until, notes)
OVERRIDING SYSTEM VALUE
SELECT g, ((g - 1) % 10000) + 1,
       ((((g - 1) % 10000) * 37 + ((g - 1) / 10000) * 101) % 1000) + 1,
       (ARRAY['Producer', 'Director', 'Editor', 'Camera Operator', 'Sound Engineer'])[((g - 1) / 10000) + 1],
       DATE '2025-01-01' + (((g - 1) % 10000) % 365),
       CASE WHEN g % 3 = 0
            THEN DATE '2025-01-01' + (((g - 1) % 10000) % 365) + 730 ELSE NULL END,
       format('Synthetic assignment %s', g)
FROM generate_series(1, 50000) AS gs(g);

INSERT INTO media_asset (asset_id, project_id, uploaded_by, asset_name, asset_type,
                         file_uri, file_format, file_size_bytes, duration_seconds,
                         version_number, status, created_at)
OVERRIDING SYSTEM VALUE
SELECT g, ((g - 1) % 10000) + 1, ((g * 17 - 1) % 1000) + 1,
       format('Asset %s', (((g - 1) / 10000) / 5) + 1),
       (ARRAY['video', 'audio', 'image', 'document', 'other'])[((g - 1) % 5) + 1],
       format('s3://simulated-media/project-%s/asset-%s.dat', ((g - 1) % 10000) + 1, g),
       (ARRAY['mp4', 'wav', 'png', 'pdf', 'mov'])[((g - 1) % 5) + 1],
       1000000::bigint + (g % 10000)::bigint * 250000,
       CASE WHEN g % 5 IN (0, 1, 4) THEN (30 + (g % 1800))::numeric(12, 3) ELSE NULL END,
       ((g - 1) / 10000) % 5 + 1,
       (ARRAY['raw', 'editing', 'review', 'approved', 'archived'])[
           (((g - 1) / 10000) % 5) + 1],
       TIMESTAMPTZ '2026-01-01 08:00:00+01' + (g % 365) * INTERVAL '1 day'
           + (g % 12) * INTERVAL '1 hour'
FROM generate_series(1, 500000) AS gs(g);

INSERT INTO equipment_reservation (reservation_id, equipment_id, project_id,
                                   reserved_by, start_at, end_at, status,
                                   purpose, created_at)
OVERRIDING SYSTEM VALUE
SELECT g, ((g - 1) % 5000) + 1, ((g * 13 - 1) % 10000) + 1,
       ((g * 17 - 1) % 900) + 1,
       TIMESTAMPTZ '2026-01-01 00:00:00+01'
           + ((((g - 1) / 5000) * 9) + (((g - 1) % 5000) % 9)) * INTERVAL '1 day'
           + (((g - 1) % 5000) % 12) * INTERVAL '2 hours',
       TIMESTAMPTZ '2026-01-01 00:00:00+01'
           + ((((g - 1) / 5000) * 9) + (((g - 1) % 5000) % 9)) * INTERVAL '1 day'
           + (((g - 1) % 5000) % 12) * INTERVAL '2 hours'
           + (2 + (g % 7)) * INTERVAL '1 hour',
       (ARRAY['pending', 'confirmed', 'checked_out', 'returned', 'cancelled'])[
           ((((g - 1) % 5000) + ((g - 1) / 5000)) % 5) + 1],
       format('Synthetic reservation %s', g),
       TIMESTAMPTZ '2025-12-01 09:00:00+01' + (g % 30) * INTERVAL '1 day'
FROM generate_series(1, 200000) AS gs(g);

SELECT setval(pg_get_serial_sequence('client', 'client_id'), 500, true);
SELECT setval(pg_get_serial_sequence('project', 'project_id'), 10000, true);
SELECT setval(pg_get_serial_sequence('staff', 'staff_id'), 1000, true);
SELECT setval(pg_get_serial_sequence('project_assignment', 'assignment_id'), 50000, true);
SELECT setval(pg_get_serial_sequence('media_asset', 'asset_id'), 500000, true);
SELECT setval(pg_get_serial_sequence('equipment', 'equipment_id'), 5000, true);
SELECT setval(pg_get_serial_sequence('equipment_reservation', 'reservation_id'), 200000, true);
COMMIT;
ANALYZE;
SELECT (SELECT count(*) FROM client) AS client,
       (SELECT count(*) FROM project) AS project,
       (SELECT count(*) FROM staff) AS staff,
       (SELECT count(*) FROM project_assignment) AS project_assignment,
       (SELECT count(*) FROM media_asset) AS media_asset,
       (SELECT count(*) FROM equipment) AS equipment,
       (SELECT count(*) FROM equipment_reservation) AS equipment_reservation;

