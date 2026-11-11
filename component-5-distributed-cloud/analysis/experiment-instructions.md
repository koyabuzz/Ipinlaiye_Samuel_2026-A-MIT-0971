# Reproducible experiment

1. Confirm all `mit8103_c5_*` volumes and `mit8103-c5-*` containers are absent.
2. Generate ignored `.env` credentials and a 600-character ignored keyfile.
3. Validate redacted Compose configuration and start the three members.
4. Authenticate to `mongo1`, run `01-init-replica-set.js`, and wait for one
   PRIMARY plus two SECONDARY members.
5. Run `02-generate-data.js` on the primary with majority write concern.
6. Verify count and ordered IDs from each member; use an authenticated direct
   secondary connection with `secondaryPreferred`.
7. Record `03-status-and-consistency.js` and identify the current primary.
8. Stop only that primary service, poll the remaining members for a new primary,
   and record the election.
9. Insert `DPRJ-0031` through the new primary using majority write concern.
10. Restart the former primary, wait until all members are healthy, and verify
    identical count 31 and IDs on all nodes.
11. Never use `docker compose down --volumes`; retain all evidence and volumes.

