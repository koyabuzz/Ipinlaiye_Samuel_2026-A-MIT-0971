# MongoDB document model

The project document is the main aggregate. Client contact data, bounded crew
assignments, schedule, tags, and summary values are embedded because they are
small and commonly read with the project. Crew entries also retain `staffId`, so
authoritative employment state stays in `staff` while the project preserves a
role-specific display snapshot.

Media assets are separate because asset counts can grow without bound. Their
version arrays are embedded and limited to five. Equipment and reservations are
separate because each equipment item participates in many reservations and the
history grows independently of a project. Reservations use references plus a
small display snapshot.

Validators enforce required fields, BSON types, enumerated states, identifier
patterns, and maximum array sizes. `08-verify.js` checks every generated
reference, snapshot, and array bound after loading.

MongoDB indexes do not reproduce PostgreSQL's GiST exclusion constraint. The
reservation index helps retrieval but does not itself prevent overlapping time
ranges; a production MongoDB design needs application-level coordination, a
transactional slot model, or another concurrency strategy.

