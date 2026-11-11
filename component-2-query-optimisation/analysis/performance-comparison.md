# Performance comparison

> Observed values below come from genuine PostgreSQL 18.4 output saved under
> `evidence/component-2/`. This is an AI-assisted technical interpretation, not
> a student reflection.

## Observed database results

The generator retained 766,500 rows. Query 1 produced 1,265 qualifying groups
(and returned its top 50), Query 2 returned 900 staff rows, and Query 3 returned
389 reservation rows.

| Query | Baseline times (ms) | Optimised times (ms) | Baseline median | Optimised median | Change |
|---|---|---|---:|---:|---:|
| 1 | 27.374, 25.468, 24.040, 23.674, 22.969 | 7.198, 6.781, 6.572, 6.504, 6.489 | 24.040 ms | 6.572 ms | 72.66% faster |
| 2 | 18.426, 17.101, 16.995, 17.189, 17.116 | 17.884, 17.154, 18.233, 17.795, 17.153 | 17.116 ms | 17.795 ms | 3.97% slower |
| 3 | 14.426, 13.577, 13.727, 12.786, 12.830 | 4.365, 3.753, 3.775, 3.722, 3.765 | 13.577 ms | 3.765 ms | 72.27% faster |

Median buffer and scan observations:

| Query | Baseline | Optimised |
|---|---|---|
| 1 | Parallel sequential scan of `media_asset`; 19,531 shared buffers (11,662 hits, 7,869 reads) | Index-only scan using `ix_media_asset_review_created_project`; 367 shared-buffer hits and no reads |
| 2 | Sequential scan of all 50,000 `project_assignment` rows; 765 shared-buffer hits | Same sequential scan and 765 hits; candidate index unused |
| 3 | Parallel sequential scan of `equipment_reservation`; 3,282 shared-buffer hits | Index-only scan using `ix_reservation_blocking_start`; 544 shared-buffer hits |

Candidate index sizes were 25 MB for the media index, 1,840 kB for the
assignment index, and 3,896 kB for the reservation index.

## Technical interpretation

Query 1 benefited because status and creation-time predicates selected 24,785
asset rows from 500,000. The covering index supplied `project_id` and
`file_size_bytes`, allowing an index-only scan instead of reading the full asset
table. The estimate of 24,255 rows was close to the actual 24,785.

Query 2 selected or examined a large proportion of the 50,000 assignment rows.
PostgreSQL correctly retained a sequential scan, so
`ix_assignment_staff_dates_project` was unused. Its slightly worse median is
ordinary run-to-run variation plus index/statistics context, not an improvement.
Removing this unused candidate is a proposed action only; it has not been
dropped.

Query 3 benefited from the partial covering index because only blocking statuses
are stored and the date boundary can be applied through the leading `start_at`
column. The plan read 1,572 qualifying reservation-index rows before joins and
returned 389 camera rows. Its estimate of 20,958 was much higher than the actual
1,572, indicating correlation between `start_at`, `end_at`, and the deterministic
data that ordinary statistics did not model well.

## Experiment limitations

- These are local, warm-cache measurements from one Apple Silicon machine.
- PostgreSQL shared buffers and macOS filesystem caches were not cleared.
- Query 1 baseline reads declined across runs as more pages entered cache.
- Index creation can itself warm index and table pages.
- Five observations reduce noise but do not provide production-scale certainty.
- Deterministic synthetic values have stronger correlations than typical media
  operations and may affect estimates and planner choices.
- `EXPLAIN ANALYZE` adds measurement overhead, though it was used consistently.
- Only read-query performance was measured. Extra indexes consume storage and
  add work to later inserts and updates.

## Student reflection

Intentionally left for the student to write independently after checking the
plans and reproducing the calculations.


