# ACID and concurrency controls

This is an AI-assisted technical explanation for review, not a personal student
reflection.

- **Atomicity:** rollback removes every change in its transaction; commit makes
  all successful statements take effect together.
- **Consistency:** foreign keys, checks, the active-staff trigger, and the GiST
  exclusion constraint prevent invalid committed states.
- **Isolation:** PostgreSQL MVCC controls statement or transaction snapshots,
  while locks and exclusion checks serialize incompatible reservations.
- **Durability:** committed fixture rows remain visible to later transactions
  until the targeted cleanup commits.

When two sessions propose overlapping blocking reservations, the second GiST
exclusion check cannot decide the result while the first transaction is open.
It waits for that transaction. If the first commits, the second receives
exclusion violation 23P01; if the first rolls back, the second may continue.

Under READ COMMITTED, each statement receives a fresh snapshot, so two reads in
one transaction may observe an intervening commit. Under REPEATABLE READ, the
transaction continues using one snapshot. PostgreSQL MVCC normally permits the
writer to commit while the repeatable-read session only reads.

`pg_stat_activity`, `pg_blocking_pids()`, and `pg_locks` show the real session
states, blocker PID, wait event, lock type, mode, and granted state. Exact rows
must be interpreted from captured output rather than assumed in advance.

