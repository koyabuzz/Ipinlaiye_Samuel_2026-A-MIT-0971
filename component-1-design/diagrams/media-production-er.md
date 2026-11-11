# Media Production Database ER Diagram (Draft)

> Review draft produced with AI assistance. Verify the entities, optionality,
> and relationship labels before using it in assessed work.

```mermaid
erDiagram
    CLIENT ||--o{ PROJECT : commissions
    PROJECT ||--o{ PROJECT_ASSIGNMENT : has
    STAFF ||--o{ PROJECT_ASSIGNMENT : receives
    PROJECT ||--o{ MEDIA_ASSET : contains
    STAFF o|--o{ MEDIA_ASSET : uploads
    PROJECT ||--o{ EQUIPMENT_RESERVATION : requires
    EQUIPMENT ||--o{ EQUIPMENT_RESERVATION : is_booked_in
    STAFF ||--o{ EQUIPMENT_RESERVATION : makes

    CLIENT {
        integer client_id PK
        varchar client_name
        varchar contact_name
        varchar email
        varchar phone
        text billing_address
        timestamptz created_at
    }

    PROJECT {
        integer project_id PK
        integer client_id FK
        varchar project_name
        text description
        varchar project_type
        varchar status
        date start_date
        date end_date
        numeric budget
        timestamptz created_at
    }

    STAFF {
        integer staff_id PK
        varchar first_name
        varchar last_name
        varchar email UK
        varchar phone
        varchar job_title
        varchar employment_type
        date hire_date
        boolean active
    }

    PROJECT_ASSIGNMENT {
        integer assignment_id PK
        integer project_id FK
        integer staff_id FK
        varchar role_name
        date assigned_from
        date assigned_until
        text notes
    }

    MEDIA_ASSET {
        integer asset_id PK
        integer project_id FK
        integer uploaded_by FK
        varchar asset_name
        varchar asset_type
        text file_uri UK
        varchar file_format
        bigint file_size_bytes
        numeric duration_seconds
        integer version_number
        varchar status
        timestamptz created_at
    }

    EQUIPMENT {
        integer equipment_id PK
        varchar asset_tag UK
        varchar equipment_name
        varchar equipment_type
        varchar manufacturer
        varchar model
        varchar serial_number UK
        varchar condition
        boolean active
    }

    EQUIPMENT_RESERVATION {
        integer reservation_id PK
        integer equipment_id FK
        integer project_id FK
        integer reserved_by FK
        timestamptz start_at
        timestamptz end_at
        varchar status
        text purpose
        timestamptz created_at
    }
```

`MEDIA_ASSET.uploaded_by` is nullable, so each asset has zero or one uploader;
one staff member may upload zero or many assets. Every other foreign key is
`NOT NULL`: each child row has exactly one referenced parent, while a parent may
have zero or many child rows. The diagram shows structure; the SQL draft contains
the detailed checks and the rule that prevents overlapping confirmed or
checked-out reservations.

