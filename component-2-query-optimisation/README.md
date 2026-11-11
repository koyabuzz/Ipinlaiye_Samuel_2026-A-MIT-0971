# Component 2: Query Processing and Optimisation

> These are AI-assisted implementation and evidence drafts for student review.
> The student must understand the queries, verify the evidence, and write their
> own reflection.

This component uses deterministic synthetic data to compare three operational
queries before and after adding candidate indexes. PostgreSQL chooses all plans
normally; no planner settings are forced.

## Scripts

Run against `mit8103_media_portfolio` in numeric order:

1. `sql/01_verify_empty_database.sql`
2. `sql/02_generate_synthetic_data.sql`
3. `sql/03_analytical_queries.sql`
4. `sql/04_baseline_explain.sql`
5. `sql/05_create_optimisation_indexes.sql`
6. `sql/06_optimised_explain.sql`

The generator has a safety guard and refuses to run unless all seven application
tables are empty. It inserts 766,500 rows and retains them for later portfolio
work. Run one unrecorded warm-up separately, then use the EXPLAIN scripts to
record five `EXPLAIN (ANALYZE, BUFFERS, SETTINGS)` plans for each query.

See `analysis/experiment-design.md` for query explanations and
`analysis/performance-comparison.md` for observed results. Genuine command
output is stored in `evidence/component-2/`.


