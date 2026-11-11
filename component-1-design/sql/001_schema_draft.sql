-- MIT8103 Component 1 review draft
-- Produced with AI assistance; review and understand before execution.
-- Intended only for a new, isolated PostgreSQL 18.4 project database.

BEGIN;

-- Required for the GiST equality operator used by the reservation exclusion
-- constraint. btree_gist is a standard PostgreSQL supplied extension.
CREATE EXTENSION IF NOT EXISTS btree_gist;

CREATE TABLE client (
    client_id integer GENERATED ALWAYS AS IDENTITY,
    client_name varchar(150) NOT NULL,
    contact_name varchar(150) NOT NULL,
    email varchar(254),
    phone varchar(40),
    billing_address text,
    created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_client PRIMARY KEY (client_id),
    CONSTRAINT ck_client_name_not_blank CHECK (btrim(client_name) <> ''),
    CONSTRAINT ck_client_contact_not_blank CHECK (btrim(contact_name) <> '')
);

CREATE TABLE project (
    project_id integer GENERATED ALWAYS AS IDENTITY,
    client_id integer NOT NULL,
    project_name varchar(200) NOT NULL,
    description text,
    project_type varchar(30) NOT NULL,
    status varchar(20) NOT NULL DEFAULT 'planned',
    start_date date,
    end_date date,
    budget numeric(14, 2),
    created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_project PRIMARY KEY (project_id),
    CONSTRAINT fk_project_client FOREIGN KEY (client_id)
        REFERENCES client (client_id) ON DELETE RESTRICT,
    CONSTRAINT ck_project_name_not_blank CHECK (btrim(project_name) <> ''),
    CONSTRAINT ck_project_type CHECK (
        project_type IN ('video', 'audio', 'photography', 'animation', 'other')
    ),
    CONSTRAINT ck_project_status CHECK (
        status IN ('planned', 'active', 'on_hold', 'completed', 'cancelled')
    ),
    CONSTRAINT ck_project_dates CHECK (
        end_date IS NULL OR start_date IS NULL OR end_date >= start_date
    ),
    CONSTRAINT ck_project_budget CHECK (budget IS NULL OR budget >= 0)
);

CREATE TABLE staff (
    staff_id integer GENERATED ALWAYS AS IDENTITY,
    first_name varchar(100) NOT NULL,
    last_name varchar(100) NOT NULL,
    email varchar(254),
    phone varchar(40),
    job_title varchar(100) NOT NULL,
    employment_type varchar(20) NOT NULL,
    hire_date date,
    active boolean NOT NULL DEFAULT true,
    CONSTRAINT pk_staff PRIMARY KEY (staff_id),
    CONSTRAINT ck_staff_first_name_not_blank CHECK (btrim(first_name) <> ''),
    CONSTRAINT ck_staff_last_name_not_blank CHECK (btrim(last_name) <> ''),
    CONSTRAINT ck_staff_job_title_not_blank CHECK (btrim(job_title) <> ''),
    CONSTRAINT ck_staff_email_not_blank CHECK (
        email IS NULL OR btrim(email) <> ''
    ),
    CONSTRAINT ck_staff_employment_type CHECK (
        employment_type IN ('employee', 'freelancer')
    )
);

-- Expression index makes supplied addresses case-insensitively unique. The
-- partial predicate leaves NULL (an email not supplied) unrestricted.
CREATE UNIQUE INDEX uq_staff_email_ci
    ON staff (lower(email))
    WHERE email IS NOT NULL;

CREATE TABLE project_assignment (
    assignment_id integer GENERATED ALWAYS AS IDENTITY,
    project_id integer NOT NULL,
    staff_id integer NOT NULL,
    role_name varchar(100) NOT NULL,
    assigned_from date NOT NULL,
    assigned_until date,
    notes text,
    CONSTRAINT pk_project_assignment PRIMARY KEY (assignment_id),
    CONSTRAINT fk_assignment_project FOREIGN KEY (project_id)
        REFERENCES project (project_id) ON DELETE RESTRICT,
    CONSTRAINT fk_assignment_staff FOREIGN KEY (staff_id)
        REFERENCES staff (staff_id) ON DELETE RESTRICT,
    CONSTRAINT uq_assignment_role_start UNIQUE (
        project_id, staff_id, role_name, assigned_from
    ),
    CONSTRAINT ck_assignment_role_not_blank CHECK (btrim(role_name) <> ''),
    CONSTRAINT ck_assignment_dates CHECK (
        assigned_until IS NULL OR assigned_until >= assigned_from
    )
);

CREATE TABLE media_asset (
    asset_id integer GENERATED ALWAYS AS IDENTITY,
    project_id integer NOT NULL,
    uploaded_by integer,
    asset_name varchar(200) NOT NULL,
    asset_type varchar(20) NOT NULL,
    file_uri text NOT NULL,
    file_format varchar(20) NOT NULL,
    file_size_bytes bigint,
    duration_seconds numeric(12, 3),
    version_number integer NOT NULL DEFAULT 1,
    status varchar(20) NOT NULL DEFAULT 'raw',
    created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_media_asset PRIMARY KEY (asset_id),
    CONSTRAINT fk_asset_project FOREIGN KEY (project_id)
        REFERENCES project (project_id) ON DELETE RESTRICT,
    CONSTRAINT fk_asset_uploader FOREIGN KEY (uploaded_by)
        REFERENCES staff (staff_id) ON DELETE SET NULL,
    CONSTRAINT uq_asset_file_uri UNIQUE (file_uri),
    CONSTRAINT uq_asset_version UNIQUE (
        project_id, asset_name, version_number
    ),
    CONSTRAINT ck_asset_name_not_blank CHECK (btrim(asset_name) <> ''),
    CONSTRAINT ck_asset_type CHECK (
        asset_type IN ('video', 'audio', 'image', 'document', 'other')
    ),
    CONSTRAINT ck_asset_file_uri_not_blank CHECK (btrim(file_uri) <> ''),
    CONSTRAINT ck_asset_format_not_blank CHECK (btrim(file_format) <> ''),
    CONSTRAINT ck_asset_file_size CHECK (
        file_size_bytes IS NULL OR file_size_bytes >= 0
    ),
    CONSTRAINT ck_asset_duration CHECK (
        duration_seconds IS NULL OR duration_seconds >= 0
    ),
    CONSTRAINT ck_asset_version CHECK (version_number > 0),
    CONSTRAINT ck_asset_status CHECK (
        status IN ('raw', 'editing', 'review', 'approved', 'archived')
    )
);

CREATE TABLE equipment (
    equipment_id integer GENERATED ALWAYS AS IDENTITY,
    asset_tag varchar(50) NOT NULL,
    equipment_name varchar(150) NOT NULL,
    equipment_type varchar(50) NOT NULL,
    manufacturer varchar(100),
    model varchar(100),
    serial_number varchar(100),
    condition varchar(20) NOT NULL DEFAULT 'good',
    active boolean NOT NULL DEFAULT true,
    CONSTRAINT pk_equipment PRIMARY KEY (equipment_id),
    CONSTRAINT uq_equipment_asset_tag UNIQUE (asset_tag),
    CONSTRAINT uq_equipment_serial_number UNIQUE (serial_number),
    CONSTRAINT ck_equipment_asset_tag_not_blank CHECK (btrim(asset_tag) <> ''),
    CONSTRAINT ck_equipment_name_not_blank CHECK (btrim(equipment_name) <> ''),
    CONSTRAINT ck_equipment_type_not_blank CHECK (btrim(equipment_type) <> ''),
    CONSTRAINT ck_equipment_condition CHECK (
        condition IN ('good', 'fair', 'damaged', 'repair', 'retired')
    )
);

CREATE TABLE equipment_reservation (
    reservation_id integer GENERATED ALWAYS AS IDENTITY,
    equipment_id integer NOT NULL,
    project_id integer NOT NULL,
    reserved_by integer NOT NULL,
    start_at timestamptz NOT NULL,
    end_at timestamptz NOT NULL,
    status varchar(20) NOT NULL DEFAULT 'pending',
    purpose text,
    created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_equipment_reservation PRIMARY KEY (reservation_id),
    CONSTRAINT fk_reservation_equipment FOREIGN KEY (equipment_id)
        REFERENCES equipment (equipment_id) ON DELETE RESTRICT,
    CONSTRAINT fk_reservation_project FOREIGN KEY (project_id)
        REFERENCES project (project_id) ON DELETE RESTRICT,
    CONSTRAINT fk_reservation_staff FOREIGN KEY (reserved_by)
        REFERENCES staff (staff_id) ON DELETE RESTRICT,
    CONSTRAINT ck_reservation_period CHECK (end_at > start_at),
    CONSTRAINT ck_reservation_status CHECK (
        status IN ('pending', 'confirmed', 'checked_out', 'returned', 'cancelled')
    ),
    CONSTRAINT ex_reservation_no_active_overlap EXCLUDE USING gist (
        equipment_id WITH =,
        tstzrange(start_at, end_at, '[)') WITH &&
    ) WHERE (status IN ('confirmed', 'checked_out'))
);

-- A cross-table CHECK constraint cannot inspect staff.active. This trigger
-- rejects a new reservation (or a change of reserver) when the named staff
-- member exists but is inactive. The foreign key handles nonexistent staff.
CREATE FUNCTION check_reservation_staff_active()
RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
    staff_is_active boolean;
BEGIN
    SELECT active
      INTO staff_is_active
      FROM staff
     WHERE staff_id = NEW.reserved_by;

    IF NOT FOUND THEN
        RETURN NEW;
    END IF;

    IF NOT staff_is_active THEN
        RAISE EXCEPTION 'Staff member % is inactive and cannot make a reservation',
            NEW.reserved_by
            USING ERRCODE = '23514';
    END IF;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_reservation_staff_active
BEFORE INSERT OR UPDATE OF reserved_by ON equipment_reservation
FOR EACH ROW
EXECUTE FUNCTION check_reservation_staff_active();

COMMIT;

