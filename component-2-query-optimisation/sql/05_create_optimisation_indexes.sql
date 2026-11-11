\set ON_ERROR_STOP on
\timing on
CREATE INDEX ix_media_asset_review_created_project
    ON media_asset (status, created_at, project_id) INCLUDE (file_size_bytes);
CREATE INDEX ix_assignment_staff_dates_project
    ON project_assignment (staff_id, assigned_from, project_id) INCLUDE (assigned_until);
CREATE INDEX ix_reservation_blocking_start
    ON equipment_reservation (start_at, equipment_id)
    INCLUDE (end_at, project_id, reserved_by)
    WHERE status IN ('confirmed', 'checked_out');
ANALYZE media_asset;
ANALYZE project_assignment;
ANALYZE equipment_reservation;
SELECT indexname, indexdef FROM pg_indexes WHERE schemaname='public'
AND indexname IN ('ix_media_asset_review_created_project',
                  'ix_assignment_staff_dates_project',
                  'ix_reservation_blocking_start') ORDER BY indexname;

