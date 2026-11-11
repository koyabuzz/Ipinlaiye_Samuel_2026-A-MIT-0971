# MIT8103 Advanced Database Systems Portfolio

- **Student:** Samuel Oluwakoya Ipinlaiye
- **Matriculation number:** 2026/A/MIT/0971
- **Programme:** Master of Information Technology
- **Institution:** Miva University
- **Course:** MIT8103 — Advanced Database Systems
- **Project:** Media Production and Asset Management Database

## Portfolio overview

This repository contains five completed database exercises for a fictional
media production company. The case study manages clients, projects, employees
and freelancers, media assets, project roles, equipment, and reservations.
PostgreSQL provides the normalised operational database and transaction
controls. MongoDB demonstrates a document model and a separate local
three-member distributed deployment.

The scripts and explanations were produced with AI assistance and checked
through actual database execution. Genuine terminal output is retained under
`evidence/`. The student must understand and review the work before
submission; the final personal reflection remains a student task.

## Implemented components and results

1. **Database Design and Modelling** — Seven PostgreSQL tables, a Mermaid
   Crow's Foot ERD, 3NF rationale, foreign keys, checks, case-insensitive email
   uniqueness, an active-staff trigger, and a GiST exclusion constraint. The
   rollback-only suite passed 11 of 11 checks.
2. **Query Processing and Optimisation** — A deterministic 766,500-row dataset,
   three analytical queries, and five baseline and five optimised plans per
   query. Median times changed from 24.040 to 6.572 ms for Query 1, 17.116 to
   17.795 ms for Query 2 (candidate index unused), and 13.577 to 3.765 ms for
   Query 3.
3. **Transactions and Concurrency** — Genuine `COMMIT`/`ROLLBACK` tests,
   two-session reservation conflicts, lock monitoring, cleanup, and a comparison
   of `READ COMMITTED` with `REPEATABLE READ`.
4. **NoSQL and Advanced Data Models** — Five validated MongoDB collections with
   12,350 deterministic documents, CRUD and aggregation examples, reference and
   snapshot checks, bounded arrays, and a `COLLSCAN`-to-`IXSCAN` comparison.
   The indexed query examined 554 rather than 10,000 documents; its reported
   time changed from 5 ms to 4 ms.
5. **Distributed and Cloud Database Concepts** — A local authenticated
   three-node MongoDB replica set. It demonstrated majority writes, secondary
   reads, primary election in approximately four seconds, recovery of the former
   primary, and 31 matching final documents on every member. This is a local
   distributed exercise, not a cloud deployment.

Detailed interpretations and limitations accompany the evidence. Local timing
results should not be generalised as production benchmarks.

## Architecture and prerequisites

- macOS on Apple Silicon
- PostgreSQL 18.4 supplied by Postgres.app
- `psql`, `createdb`, Git, and a POSIX-compatible shell
- Docker Desktop with Docker Compose
- MongoDB Community image `mongo:8.2.12-noble`
- Sufficient Docker memory for the Component 5 three-node replica set

PostgreSQL database: `mit8103_media_portfolio`. Components 4 and 5 use
separate MongoDB deployments, credentials, networks, and named volumes.
Credentials belong in ignored `.env` files; Component 5 member authentication
also uses an ignored keyfile. Never commit either secret.

## Repository structure

```text
component-1-design/                 ERD, PostgreSQL schema and validation tests
component-2-query-optimisation/     Generator, queries, plans and comparison
component-3-transactions/           Transaction, concurrency and isolation tests
component-4-nosql/                  MongoDB document model and single-node Compose
component-5-distributed-cloud/      Authenticated three-node replica set
docs/                               Project overview, decisions and final report
evidence/component-1/               Genuine design-validation output
evidence/component-2/               Genuine PostgreSQL plans and measurements
evidence/component-3/               Genuine multi-session and lock output
evidence/component-4/               Genuine MongoDB outputs and explain plans
evidence/component-5/               Genuine replication and failover output
```

Start with each component's `README.md`, then read its `analysis/` material
before executing scripts. The submission report draft is
[`docs/final-report.md`](docs/final-report.md).

## Reproducibility

### PostgreSQL components

For a **new isolated environment**, confirm the database name is unused before
creating it. Do not run the schema against an unrelated database.

```bash
pg_isready
psql --dbname=postgres --command="SELECT datname FROM pg_database WHERE datname = 'mit8103_media_portfolio';"
createdb mit8103_media_portfolio
psql --dbname=mit8103_media_portfolio --no-psqlrc \
  --set=ON_ERROR_STOP=1 --file=component-1-design/sql/001_schema_draft.sql
psql --dbname=mit8103_media_portfolio --no-psqlrc \
  --set=ON_ERROR_STOP=1 --file=component-1-design/sql/002_validation_tests.sql
```

Component 2 scripts run in numeric order after Component 1. Its generator
refuses to run unless all seven tables are empty. Component 3 is a coordinated
multi-session experiment; follow its experiment instructions exactly and use
its targeted cleanup.

For the **existing validated environment**, do not recreate the database or
rerun data generation. Inspect it with `psql` and compare its catalog and row
counts with the preserved evidence.

### MongoDB components

For a **first-time deployment**, copy each `.env.example` to an ignored
`.env`, replace the placeholders with strong local credentials, verify that
the named volumes and database are unused, and follow that component's
experiment instructions. Components 4 and 5 are independent Compose projects.

For an **existing retained deployment**, do not repeat initialisation or delete
volumes. Use `docker compose ps` from the relevant component directory and
authenticated read-only inspection. Never run `docker compose down --volumes`.

The evidence records the original experiment runs. Re-execution can produce new
PIDs, transaction IDs, election times, buffer activity, and execution timings.

## Evidence and academic integrity

Evidence files contain real command output, including documented failed setup
attempts retained for transparency. They are not fabricated screenshots or
invented benchmarks. AI assisted planning, implementation, debugging, and
documentation; claims were checked against actual PostgreSQL and MongoDB
execution evidence. Personal reflection and final wording must be reviewed and
completed by the student.

The official assignment brief is not stored in this repository. Before final
submission, confirm the required repository naming convention, report format,
screenshot requirements, assessor GitHub account, and submission-portal steps.

