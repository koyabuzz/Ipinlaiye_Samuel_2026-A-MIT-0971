-- MIT8103 Component 1 validation; all sample data is rolled back.
BEGIN;

CREATE TEMP TABLE validation_result (
    test_name text PRIMARY KEY,
    outcome text NOT NULL CHECK (outcome IN ('PASS', 'FAIL')),
    detail text NOT NULL
) ON COMMIT DROP;

DO $$
DECLARE
    actual_count integer;
BEGIN
    SELECT count(*) INTO actual_count
    FROM information_schema.tables
    WHERE table_schema = 'public' AND table_type = 'BASE TABLE'
      AND table_name IN (
          'client', 'project', 'staff', 'project_assignment', 'media_asset',
          'equipment', 'equipment_reservation'
      );
    INSERT INTO validation_result VALUES (
        '01 seven application tables',
        CASE WHEN actual_count = 7 THEN 'PASS' ELSE 'FAIL' END,
        format('expected 7, found %s', actual_count)
    );

    SELECT count(*) INTO actual_count
    FROM pg_constraint c JOIN pg_namespace n ON n.oid = c.connamespace
    WHERE n.nspname = 'public' AND c.contype = 'p'
      AND c.conrelid IN (
          'client'::regclass, 'project'::regclass, 'staff'::regclass,
          'project_assignment'::regclass, 'media_asset'::regclass,
          'equipment'::regclass, 'equipment_reservation'::regclass
      );
    INSERT INTO validation_result VALUES (
        '02 primary keys',
        CASE WHEN actual_count = 7 THEN 'PASS' ELSE 'FAIL' END,
        format('expected 7, found %s', actual_count)
    );

    SELECT count(*) INTO actual_count
    FROM pg_constraint c JOIN pg_namespace n ON n.oid = c.connamespace
    WHERE n.nspname = 'public' AND c.contype = 'f'
      AND c.conrelid IN (
          'project'::regclass, 'project_assignment'::regclass,
          'media_asset'::regclass, 'equipment_reservation'::regclass
      );
    INSERT INTO validation_result VALUES (
        '03 foreign keys',
        CASE WHEN actual_count = 8 THEN 'PASS' ELSE 'FAIL' END,
        format('expected 8, found %s', actual_count)
    );
END;
$$;

INSERT INTO client (client_id, client_name, contact_name, email)
OVERRIDING SYSTEM VALUE
VALUES (900001, 'Validation Client', 'Ada Reviewer', 'client@example.test');

INSERT INTO project (
    project_id, client_id, project_name, project_type, status, start_date
)
OVERRIDING SYSTEM VALUE
VALUES (
    910001, 900001, 'Validation Production', 'video', 'active', DATE '2026-11-10'
);

INSERT INTO staff (
    staff_id, first_name, last_name, email, job_title, employment_type, active
)
OVERRIDING SYSTEM VALUE
VALUES
    (920001, 'Active', 'Producer', 'Producer@Example.test', 'Producer', 'employee', true),
    (920002, 'Inactive', 'Operator', 'inactive@example.test', 'Operator', 'freelancer', false),
    (920003, 'NoEmail', 'One', NULL, 'Assistant', 'employee', true),
    (920004, 'NoEmail', 'Two', NULL, 'Assistant', 'freelancer', true);

INSERT INTO equipment (
    equipment_id, asset_tag, equipment_name, equipment_type, condition
)
OVERRIDING SYSTEM VALUE
VALUES (930001, 'CAM-TEST-001', 'Validation Camera', 'camera', 'good');

INSERT INTO validation_result VALUES (
    '04 multiple NULL staff emails', 'PASS',
    'two staff rows with NULL email inserted successfully'
);

DO $$
BEGIN
    BEGIN
        INSERT INTO staff (
            first_name, last_name, email, job_title, employment_type
        ) VALUES (
            'Duplicate', 'Email', 'producer@example.test', 'Editor', 'employee'
        );
        INSERT INTO validation_result VALUES (
            '05 case-insensitive email uniqueness', 'FAIL',
            'email differing only by case was accepted'
        );
    EXCEPTION WHEN unique_violation THEN
        INSERT INTO validation_result VALUES (
            '05 case-insensitive email uniqueness', 'PASS',
            'email differing only by case was rejected'
        );
    END;
END;
$$;

DO $$
BEGIN
    BEGIN
        INSERT INTO equipment_reservation (
            equipment_id, project_id, reserved_by, start_at, end_at, status
        ) VALUES (
            930001, 910001, 920002,
            '2026-12-01 09:00+01', '2026-12-01 10:00+01', 'pending'
        );
        INSERT INTO validation_result VALUES (
            '06 inactive staff trigger', 'FAIL',
            'inactive staff member was allowed to reserve'
        );
    EXCEPTION WHEN check_violation THEN
        INSERT INTO validation_result VALUES (
            '06 inactive staff trigger', 'PASS',
            'inactive staff member was rejected with SQLSTATE 23514'
        );
    END;
END;
$$;

DO $$
BEGIN
    BEGIN
        INSERT INTO equipment_reservation (
            equipment_id, project_id, reserved_by, start_at, end_at, status
        ) VALUES
            (930001, 910001, 920001, '2026-12-02 09:00+01', '2026-12-02 11:00+01', 'pending'),
            (930001, 910001, 920001, '2026-12-02 10:00+01', '2026-12-02 12:00+01', 'pending');
        INSERT INTO validation_result VALUES (
            '07 pending overlap', 'PASS',
            'overlapping pending reservations were accepted'
        );
    EXCEPTION WHEN exclusion_violation THEN
        INSERT INTO validation_result VALUES (
            '07 pending overlap', 'FAIL',
            'overlapping pending reservations were rejected'
        );
    END;
END;
$$;

INSERT INTO equipment_reservation (
    equipment_id, project_id, reserved_by, start_at, end_at, status
)
VALUES (
    930001, 910001, 920001,
    '2026-12-03 09:00+01', '2026-12-03 11:00+01', 'confirmed'
);

DO $$
BEGIN
    BEGIN
        INSERT INTO equipment_reservation (
            equipment_id, project_id, reserved_by, start_at, end_at, status
        ) VALUES (
            930001, 910001, 920001,
            '2026-12-03 10:00+01', '2026-12-03 12:00+01', 'checked_out'
        );
        INSERT INTO validation_result VALUES (
            '08 blocking overlap', 'FAIL',
            'overlapping checked-out reservation was accepted'
        );
    EXCEPTION WHEN exclusion_violation THEN
        INSERT INTO validation_result VALUES (
            '08 blocking overlap', 'PASS',
            'overlapping confirmed/checked-out reservation was rejected'
        );
    END;
END;
$$;

DO $$
BEGIN
    BEGIN
        INSERT INTO equipment_reservation (
            equipment_id, project_id, reserved_by, start_at, end_at, status
        ) VALUES (
            930001, 910001, 920001,
            '2026-12-03 11:00+01', '2026-12-03 12:00+01', 'confirmed'
        );
        INSERT INTO validation_result VALUES (
            '09 back-to-back confirmed', 'PASS',
            'reservation starting at the prior end time was accepted'
        );
    EXCEPTION WHEN exclusion_violation THEN
        INSERT INTO validation_result VALUES (
            '09 back-to-back confirmed', 'FAIL',
            'back-to-back confirmed reservation was rejected'
        );
    END;
END;
$$;

DO $$
BEGIN
    BEGIN
        INSERT INTO equipment_reservation (
            equipment_id, project_id, reserved_by, start_at, end_at, status
        ) VALUES
            (930001, 910001, 920001, '2026-12-03 09:30+01', '2026-12-03 10:00+01', 'cancelled'),
            (930001, 910001, 920001, '2026-12-03 10:00+01', '2026-12-03 10:30+01', 'returned');
        INSERT INTO validation_result VALUES (
            '10 historical statuses non-blocking', 'PASS',
            'overlapping cancelled and returned reservations were accepted'
        );
    EXCEPTION WHEN exclusion_violation THEN
        INSERT INTO validation_result VALUES (
            '10 historical statuses non-blocking', 'FAIL',
            'cancelled or returned reservation incorrectly blocked an overlap'
        );
    END;
END;
$$;

DO $$
BEGIN
    BEGIN
        DELETE FROM client WHERE client_id = 900001;
        INSERT INTO validation_result VALUES (
            '11 historical delete restriction', 'FAIL',
            'referenced client was deleted'
        );
    EXCEPTION WHEN integrity_constraint_violation THEN
        INSERT INTO validation_result VALUES (
            '11 historical delete restriction', 'PASS',
            'referenced client deletion was rejected'
        );
    END;
END;
$$;

SELECT test_name, outcome, detail
FROM validation_result
ORDER BY test_name;

SELECT
    count(*) FILTER (WHERE outcome = 'PASS') AS passed,
    count(*) FILTER (WHERE outcome = 'FAIL') AS failed,
    count(*) AS total
FROM validation_result;

ROLLBACK;
