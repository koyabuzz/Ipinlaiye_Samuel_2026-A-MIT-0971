# MIT8103 Advanced Database Systems Portfolio

> **Academic integrity note:** The schema, diagram, and explanatory notes in this
> repository are review drafts produced with AI assistance. They must be checked,
> understood, and revised by the student before they are used in assessed work.

## Fictional organisation

This portfolio models a fictional media production company that produces video,
audio, photography, and other digital content for clients. The company needs to
record its clients and projects, assign employees and freelancers to project
roles, catalogue media assets and their versions, and reserve production
equipment without double-booking it.

## Current scope

Only Portfolio Component 1 (database design and modelling) is currently drafted.
The relational model contains seven tables:

- `client`
- `project`
- `staff`
- `project_assignment`
- `media_asset`
- `equipment`
- `equipment_reservation`

The database stores media metadata and simulated storage references, not real
video or audio files. Historical records are retained by using statuses and
active flags rather than automatically deleting related data.

Project statuses are `planned`, `active`, `on_hold`, `completed`, and
`cancelled`. Media asset statuses are `raw`, `editing`, `review`, `approved`, and
`archived`. Reservation statuses are `pending`, `confirmed`, `checked_out`,
`returned`, and `cancelled`. Only confirmed and checked-out reservations block
overlapping bookings; all statuses remain available as history.

Components 2–5 are represented only by empty placeholder folders and are not
implemented at this stage.

## Requirements

- macOS on Apple Silicon
- PostgreSQL 18.4 supplied by Postgres.app
- Git
- Docker Desktop and Docker Compose (needed for MongoDB in a later component,
  not for the current PostgreSQL draft)

## Review the design

Before running any SQL, review:

1. [The Crow's Foot ER diagram](component-1-design/diagrams/media-production-er.md)
2. [The draft PostgreSQL schema](component-1-design/sql/001_schema_draft.sql)
3. [The normalisation and constraint notes](component-1-design/notes/design-rationale.md)
4. [The validation checklist](component-1-design/notes/validation-checklist.md)

The executed validation output is recorded in
[`evidence/component-1/component-1-validation-2026-11-10.txt`](evidence/component-1/component-1-validation-2026-11-10.txt).

## Create an isolated local database

These commands create a new database and apply the reviewed Component 1 schema.
The database name must first be checked to avoid changing an existing database.

```bash
pg_isready
psql --dbname=postgres --command="SELECT datname FROM pg_database WHERE datname = 'mit8103_media_portfolio';"
createdb mit8103_media_portfolio
psql --dbname=mit8103_media_portfolio \
  --file=component-1-design/sql/001_schema_draft.sql
```

The rollback-only validation suite can be repeated with:

```bash
psql --dbname=mit8103_media_portfolio \
  --file=component-1-design/sql/002_validation_tests.sql
```

To inspect the result interactively:

```bash
psql --dbname=mit8103_media_portfolio
```

Then, inside `psql`, `\dt` lists the tables and `\d equipment_reservation`
shows the reservation constraints. Do not execute the schema against an
unrelated or important database.

## Repository layout

```text
docs/                              Project-level notes and decisions
component-1-design/                Current design and modelling draft
component-2-query-optimisation/    Reserved; not implemented
component-3-transactions/          Reserved; not implemented
component-4-nosql/                 Reserved; not implemented
component-5-distributed-cloud/     Reserved; not implemented
evidence/                          Genuine evidence added during later work
```

No GitHub repository has been created and nothing has been pushed.

