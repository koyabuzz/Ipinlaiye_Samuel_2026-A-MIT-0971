# Component 4: NoSQL and Advanced Data Models

> AI-assisted technical implementation for student review. Genuine outputs are
> retained under `evidence/component-4/`. Personal reflection is intentionally
> left to the student.

This component deploys MongoDB Community with Docker Compose and implements a
project-centred document model using five collections: `projects`, `staff`,
`mediaAssets`, `equipment`, and `equipmentReservations`.

The deployed image is pinned to `mongo:8.2.12-noble` because the earlier 8.0
image did not start on Docker Desktop's LinuxKit 7.0.12 kernel. Compatibility,
authentication, and a 90-second stability period were verified before deployment.

The deterministic dataset contains 12,350 documents. Collection validators,
bounded embedded arrays, reference checks, CRUD examples, aggregations, and a
before/after index execution-plan comparison are included.

Credentials belong only in `.env`, which is Git-ignored. Do not copy `.env` or
credential-bearing commands into evidence. See `analysis/experiment-instructions.md`.


