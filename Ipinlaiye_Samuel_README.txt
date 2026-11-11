MIT8103 ADVANCED DATABASE SYSTEMS PORTFOLIO
===========================================

Student: Samuel Oluwakoya Ipinlaiye
Student ID: 301932362
Matriculation number: 2026/A/MIT/0971
Programme: Master of Information Technology
Institution: Miva University
Course: MIT8103 - Advanced Database Systems
Project: Media Production and Asset Management Database

Public GitHub repository:
https://github.com/koyabuzz/Ipinlaiye_Samuel_301932362

PROJECT OVERVIEW
----------------
This portfolio models a fictional media production company that manages
clients, projects, employees and freelancers, media assets, production
equipment, and reservations. PostgreSQL provides the normalised operational
database, optimisation experiments, and transaction controls. MongoDB provides
the document-model and distributed-database exercises. All records are
deterministic synthetic data.

PORTFOLIO COMPONENTS
--------------------
1. Database Design and Modelling
   Seven PostgreSQL tables, Crow's Foot ER diagram, Third Normal Form rationale,
   integrity constraints, and 11 successful validation checks.

2. Query Processing and Optimisation
   A 766,500-row synthetic dataset, three analytical queries, candidate indexes,
   and genuine baseline and optimised EXPLAIN plans.

3. Transactions and Concurrency
   COMMIT and ROLLBACK demonstrations, two-session reservation conflicts, lock
   monitoring, and READ COMMITTED versus REPEATABLE READ observations.

4. NoSQL and Advanced Data Models
   Five validated MongoDB collections containing 12,350 documents, CRUD,
   aggregations, reference checks, and a before-and-after index experiment.

5. Distributed and Cloud Database Concepts
   A local authenticated three-member MongoDB replica set demonstrating
   replication, majority writes, primary election, failover, and recovery. It
   is a local distributed deployment and is not claimed as a cloud deployment.

PREREQUISITES
-------------
- macOS on Apple Silicon
- PostgreSQL 18.4 through Postgres.app
- psql, createdb, Git, and a POSIX-compatible shell
- Docker Desktop with Docker Compose
- MongoDB Community image mongo:8.2.12-noble

DIRECTORY MAP
-------------
component-1-design/                 Relational design, schema, ERD and tests
component-2-query-optimisation/     Data generator, queries and query plans
component-3-transactions/           Transaction and concurrency experiments
component-4-nosql/                  MongoDB document-model exercise
component-5-distributed-cloud/      MongoDB replica-set exercise
evidence/component-1/               Component 1 genuine output
evidence/component-2/               Component 2 genuine output
evidence/component-3/               Component 3 genuine output
evidence/component-4/               Component 4 genuine output
evidence/component-5/               Component 5 genuine output
docs/                               Project documentation and final report

FINAL REPORT
------------
docs/MIT8103_Final_Portfolio_Report_Samuel_Ipinlaiye.pdf

The editable report source is docs/final-report.md. Each component README and
analysis directory contains its reproduction instructions, observed results,
and limitations. Credentials, MongoDB keyfiles, local database volumes, and
other secrets are intentionally excluded.
