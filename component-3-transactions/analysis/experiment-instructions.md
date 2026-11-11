# Reproducible experiment instructions

Run all commands against `mit8103_media_portfolio` with `psql --no-psqlrc`.
Capture each terminal's stdout and stderr. Do not continue if the safety check
finds a reserved ID.

1. Run `00_safety_check.sql` and save its output.
2. Run `01_commit_rollback_demo.sql` in one connection.
3. Scenario A: start `02_reservation_a_commit.sql`; about half a second later
   start `03_reservation_b_conflict.sql`; while B waits, run
   `06_lock_monitor.sql` in a third connection. A commits after five seconds,
   B should report SQLSTATE 23P01 and roll back.
4. Scenario B: start `04_reservation_a_rollback.sql`; about half a second later
   start `05_reservation_b_after_rollback.sql`; run the monitor while B waits.
   A rolls back; B completes and then rolls back.
5. Run `07_isolation_fixture_setup.sql`.
6. Start `08_read_committed_a.sql`; shortly afterward run
   `09_read_committed_b.sql`. A's second read should see B's committed value.
7. Run `10_reset_isolation_fixture.sql`.
8. Start `11_repeatable_read_a.sql`; shortly afterward run
   `12_repeatable_read_b.sql`. A's second in-transaction read should retain its
   original snapshot; the read after commit should see B's value.
9. Run `13_cleanup_and_verify.sql` and compare counts with the safety output.

The sleeps are bounded coordination points, not performance measurements.
Timeouts prevent an indefinite wait. Screenshots must be taken from the actual
three terminals if required; text output remains the primary reproducible
evidence.

