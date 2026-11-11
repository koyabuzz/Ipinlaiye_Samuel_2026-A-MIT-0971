# Approved design decisions

- Use seven relational tables: `client`, `project`, `staff`,
  `project_assignment`, `media_asset`, `equipment`, and
  `equipment_reservation`.
- Use PostgreSQL 18.4 through the existing Postgres.app server.
- Use generated integer primary keys.
- Store one main contact per client.
- Support employees and freelancers.
- Permit a staff member to hold multiple roles on the same project.
- Do not track assignment hours initially.
- Do not store assignment rates; financial billing is outside scope.
- Treat supplied staff email addresses as case-insensitively unique while
  allowing multiple missing (`NULL`) emails.
- Use simple positive media version numbers and simulated storage references.
- Permit any active staff member to make a reservation.
- Do not add an equipment maintenance module.
- Retain historical records.
- Document the design with Crow's Foot notation.
- Allow pending reservations to overlap.
- Prevent overlapping confirmed or checked-out reservations for the same
  equipment; cancelled and returned reservations remain as non-blocking history.

