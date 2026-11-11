# Reproducible Component 4 instructions

1. Verify that `mit8103_component4_mongo_data` and
   `mit8103-component4-mongodb` do not already exist.
2. Create local credentials in Git-ignored `.env`; never print or capture them.
3. Validate Compose configuration, then run `docker compose up -d` from this
   component directory and wait for `healthy`.
4. Execute scripts `01` through `05` with authenticated `mongosh` inside the
   container, capturing output. Script `05` is the baseline explain and must run
   before non-`_id` indexes are created.
5. Execute `06-create-indexes.js`, followed by `07-indexed-explain.js` using the
   identical query.
6. Execute `08-verify.js` and preserve all counts, reference checks, bounds,
   validator definitions, and document samples.
7. Use `docker compose stop` after evidence capture if the service is no longer
   needed. Do not use `docker compose down --volumes`; the named volume is
   intentionally retained.

Authentication commands expand credentials only inside the container. Evidence
must contain results, not `.env`, credential values, or shell tracing.

