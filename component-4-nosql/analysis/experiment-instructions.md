# Reproducible Component 4 instructions

## First-time deployment only

1. Confirm that `mit8103_component4_mongo_data` and
   `mit8103-component4-mongodb` do not already exist. Stop if an unexpected
   deployment or initialised volume is present.
2. Copy `.env.example` to the Git-ignored `.env`, replace the placeholders
   with strong local credentials, and never print or capture them.
3. Validate Compose configuration, then run `docker compose up -d` from this
   component directory and wait for `healthy`.
4. Execute scripts `01` through `05` with authenticated `mongosh` inside
   the container, capturing output. Script `05` is the baseline explain and
   must run before non-`_id` indexes are created.
5. Execute `06-create-indexes.js`, followed by `07-indexed-explain.js` using
   the identical query.
6. Execute `08-verify.js` and preserve all counts, reference checks, bounds,
   validator definitions, and document samples.
7. Use `docker compose stop` if the service is no longer needed. Never use
   `docker compose down --volumes`; the named volume is intentionally retained.

Authentication commands expand credentials only inside the container. Evidence
must contain results, not `.env`, credential values, or shell tracing.

## Existing retained deployment

Do not repeat collection creation or data generation. Inspect service health
with `docker compose ps` and use authenticated read-only queries if current
counts must be confirmed. Compare results with `evidence/component-4/`. Do not
replace, reset, or delete the retained named volume.

