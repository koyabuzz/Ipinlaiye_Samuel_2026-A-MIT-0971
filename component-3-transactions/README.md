# Component 3: Transactions and Concurrency

> AI-assisted technical implementation for student review. Genuine outputs are
> retained under `evidence/component-3/`; personal reflection is left to the
> student.

This component demonstrates transaction boundaries, rollback versus commit,
concurrent reservation conflicts, lock observation, and PostgreSQL MVCC under
`READ COMMITTED` and `REPEATABLE READ`.

All tests use explicitly approved negative identifiers. Reservation tests use
equipment, project, and active staff ID 1 at dates in January 2035. Scripts set
bounded lock and statement timeouts. Cleanup names every permitted test ID;
there is no broad negative-ID deletion.

See `analysis/experiment-instructions.md` for the execution order and
`analysis/acid-and-concurrency.md` for the technical explanation.

The executed results are summarised in `analysis/observed-results.md`. Raw text
evidence is retained in `evidence/component-3/`, including both session outputs,
both lock snapshots, isolation results, and final cleanup verification.


