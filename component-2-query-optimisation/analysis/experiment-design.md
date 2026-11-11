# Component 2 experiment design

> AI-assisted technical draft. The student must verify the implementation and
> write their own reflection.

The deterministic generator targets 766,500 rows: 500 clients, 10,000 projects,
1,000 staff, 50,000 assignments, 500,000 assets, 5,000 equipment items, and
200,000 reservations. Fixed identifiers, dates, modular distributions, and
`generate_series()` make it reproducible. A transactional guard rejects
generation unless every application table is empty. Constraints remain enabled.

Query 1 reports active projects with at least three assets awaiting review in
the first quarter of 2026. Query 2 reports current role and project counts for
active staff. Query 3 produces a one-week schedule for blocking camera bookings.

Each phase uses identical query text and constants. One warm-up is followed by
five `EXPLAIN (ANALYZE, BUFFERS, SETTINGS)` executions. Comparison uses the
median execution time and examines scans, joins, estimates versus actual rows,
loops, buffers, sorting, planning time, and execution time. Planner parameters
are not changed. Results are warm-cache comparisons; caches are not forcibly
cleared, system load varies, and synthetic distributions limit generalisation.
A sequential scan may correctly remain preferable for a low-selectivity query.

Observed results and technical interpretation belong in the comparison report.
Personal academic reflection must be written by the student.

