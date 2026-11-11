# Observed results

> These values come from genuine MongoDB 8.2.12 execution evidence. Technical
> interpretation is separated from personal reflection, which remains for the
> student.

## Compatibility and deployment

Docker Desktop reported LinuxKit kernel `7.0.12` on ARM64. `mongo:8.0` refused
to start because of the MongoDB/TCMalloc kernel check. The exact official image
`mongo:8.2.12-noble` used ARM64 digest
`sha256:dc23b0dde2221277b581dd76933f39f8a765fee9dbd99b9deb19184c063c061f`.

An isolated disposable container accepted authenticated pings before and after
a 90-second stability period. The project service was then updated to this exact
tag. Its authenticated health check reports `healthy`, and the server reports
version `8.2.12`.

## Dataset and validation

| Collection | Documents |
|---|---:|
| `projects` | 200 |
| `staff` | 50 |
| `mediaAssets` | 10,000 |
| `equipment` | 100 |
| `equipmentReservations` | 2,000 |
| **Total** | **12,350** |

All five collections use strict error-producing validators. Verification found:

- zero missing asset-project, asset-uploader, crew-staff, reservation-project,
  reservation-equipment, or reservation-staff references;
- zero reservations made by inactive staff;
- zero client/equipment/staff snapshot mismatches;
- zero crew, tag, or version arrays outside their bounds;
- zero invalid reservation periods;
- zero remaining CRUD demonstration documents.

An intentionally incomplete project was rejected with validation error code
`121`, and its exact test ID had a final count of zero.

## CRUD observations

The exact temporary ID `PRJ-DEMO-001` was inserted successfully, read with
status `planned`, updated to status `active` with one embedded producer, and
deleted. The update reported one matched and one modified document; deletion
reported one deleted document and zero remaining.

## Aggregation observations

- Storage/status grouping produced 25 type/status groups, each containing 400
  assets in this deterministic distribution.
- The top ten review projects each contained 10 review assets.
- The highest embedded-crew workloads were 12 active project roles.
- The selected one-week confirmed/checked-out camera schedule returned three
  sample reservations.

## Index explain comparison

The identical review-asset query returned 554 documents in both phases.

| Measurement | Baseline | Indexed |
|---|---:|---:|
| Winning access stage | `COLLSCAN` plus in-memory `SORT` | `IXSCAN` via `ix_asset_status_created_project` |
| Documents returned | 554 | 554 |
| Documents examined | 10,000 | 554 |
| Keys examined | 0 | 554 |
| Reported execution time | 5 ms | 4 ms |

The index reduced documents examined by 94.46% and eliminated the separate sort.
The one-millisecond timing difference is indicative only because this is a small
local dataset and MongoDB reports integer milliseconds.

## Index inventory

- `ix_project_status_type_start`
- `uq_staff_email`
- `ix_asset_status_created_project`
- `uq_equipment_asset_tag`
- `ix_reservation_equipment_period`

Each collection also retains its automatic `_id_` index.

## Limitations

- Results come from one local ARM64 Docker Desktop environment.
- The 90-second compatibility test does not establish long-term production
  support on an affected kernel family.
- The dataset is deterministic and smaller than a production media catalogue.
- A MongoDB compound reservation index improves retrieval but does not enforce
  PostgreSQL-style exclusion of overlapping time ranges.
- The before/after explain comparison is one measured execution per phase, so
  scan work is more informative than the coarse timing difference.

## Student reflection

To be written independently after reviewing the raw evidence and scripts.


