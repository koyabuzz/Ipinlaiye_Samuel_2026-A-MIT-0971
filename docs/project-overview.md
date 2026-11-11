# Project overview

## Student and case study

Samuel Oluwakoya Ipinlaiye (`2026/A/MIT/0971`) prepared this MIT8103
portfolio for the Master of Information Technology programme at Miva
University. The case study is a fictional media production and asset management
company responsible for clients, projects, production staff, media files,
equipment, and bookings.

## Completed architecture

PostgreSQL 18.4 stores the normalised operational model in seven related tables.
Its constraints enforce referential integrity, supported status values,
case-insensitive staff-email uniqueness, active bookers, and non-overlapping
confirmed or checked-out equipment reservations. The retained 766,500-row
synthetic dataset supports the optimisation and transaction exercises.

MongoDB 8.2.12 runs through Docker Compose in two independent environments.
Component 4 implements five validated collections containing 12,350 documents.
Component 5 implements an authenticated three-member replica set with distinct
volumes and an internal network; it demonstrates replication, majority writes,
election, failover, and recovery. Component 5 is local and is not presented as
a cloud deployment.

## Validation summary

- Component 1: 11/11 rollback-only validation checks passed.
- Component 2: five baseline and five optimised measurements were preserved for
  each of three queries; two indexes materially reduced scan work and one
  candidate index was unused.
- Component 3: commit, rollback, blocking, exclusion failure, isolation-level
  visibility, cleanup, and restored row counts were observed.
- Component 4: five strict validators, all reference/snapshot checks, temporary
  cleanup, CRUD, aggregations, and the before/after explain experiment passed.
- Component 5: one primary and two secondaries were established; a new primary
  was elected after failure and all members ended with the same 31 documents.

Technical scripts, analysis, and genuine raw output are grouped by component.
The concise submission report is in `docs/final-report.md`. AI assistance is
disclosed throughout; personal reflection is reserved for the student.

The official assignment brief is not present in the repository. Repository
naming, screenshot requirements, report formatting, assessor access, and portal
submission instructions must therefore be confirmed separately.

