# Observed results

> Values in this document are transcribed from genuine PostgreSQL 18.4 output
> under `evidence/component-3/`. Interpretation is separated from observation.
> Personal reflection is intentionally reserved for the student.

## Transaction boundaries

Observed:

- Client `-310001` was visible after its insert inside the transaction.
- After `ROLLBACK`, its count was 0.
- Client `-310002` remained visible after `COMMIT`.
- Targeted cleanup deleted one committed row; its final count was 0.

Interpretation: rollback demonstrated atomicity by undoing the insert. Commit
made the second insert durable and visible to a later statement until cleanup.

## Reservation Scenario A: first transaction commits

Observed:

- Session A PID 22592 inserted reservation `-300001` and held its transaction
  for five seconds.
- Session B PID 22596 attempted overlapping reservation `-300002`.
- Monitor output showed B waiting on `wait_event_type=Lock`,
  `wait_event=transactionid`, with `blocking_pids={22592}`.
- In `pg_locks`, B held an ungranted `ShareLock` on transaction ID 753717;
  A held the granted `ExclusiveLock` for that transaction ID.
- After A committed, B waited 4492.230 ms and received SQLSTATE 23P01 from
  `ex_reservation_no_active_overlap`.
- B's next statement reported SQLSTATE 25P02 because its transaction was
  aborted, after which `ROLLBACK` succeeded.
- Targeted cleanup deleted reservation `-300001`; its final count was 0.

Interpretation: the exclusion check waited for the potentially conflicting
transaction outcome. A commit made the conflict real, so B was rejected.

## Reservation Scenario B: first transaction rolls back

Observed:

- Session A PID 22669 inserted reservation `-300003` and later rolled back.
- Session B PID 22674 attempted overlapping reservation `-300004`.
- Monitor output again showed a transaction-ID lock wait, with
  `blocking_pids={22669}` and an ungranted `ShareLock` in B.
- B's insert waited 4479.548 ms, then completed after A rolled back.
- B selected its own inserted confirmed row inside the transaction.
- B rolled back; the final count for reservation `-300004` was 0.

Interpretation: once A rolled back, its uncommitted index entry no longer caused
a committed exclusion conflict, so B could proceed.

## Isolation levels

READ COMMITTED observations:

- Session A PID 22708 first read budget `100000.00`.
- Session B PID 22711 updated and committed `110000.00`.
- Session A's second statement in the same transaction read `110000.00`.

REPEATABLE READ observations:

- After reset, Session A PID 22733 first read `100000.00`.
- Session B PID 22736 updated and committed `120000.00`.
- Session A's second read inside its transaction remained `100000.00`.
- After A committed, a new statement read `120000.00`.

Interpretation: READ COMMITTED used a fresh snapshot for the second statement;
REPEATABLE READ retained its original transaction snapshot until commit.

## Final verification

- All approved negative IDs were absent.
- Counts returned to 500 clients, 10,000 projects, 1,000 staff, 50,000
  assignments, 500,000 assets, 5,000 equipment items, and 200,000 reservations.
- All three Component 2 indexes were present.
- The exclusion constraint, three reservation foreign keys, and active-staff
  trigger were present.
- No `MIT8103_C3_%` sessions remained connected.

## Limitations

- Coordination used bounded `pg_sleep` calls; those waits are not performance
  benchmarks.
- PIDs, transaction IDs, and millisecond timings are specific to this run.
- The experiment used one local PostgreSQL instance and synthetic records.
- The monitor captured a representative point while B waited, not every lock
  transition throughout the transactions.

## Student reflection

To be written independently by the student after reviewing the scripts and raw
evidence.


