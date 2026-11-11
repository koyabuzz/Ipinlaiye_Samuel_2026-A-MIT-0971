# Observed results

> Genuine local execution results from MongoDB 8.2.12. This is a technical
> account, not a claim of cloud deployment or a personal student reflection.

## Deployment and authentication

Docker Desktop supplied 10 CPUs and approximately 8.3 GB RAM on ARM64 LinuxKit
kernel 7.0.12. Three members ran the exact image `mongo:8.2.12-noble`, digest
`sha256:dc23b0dde2221277b581dd76933f39f8a765fee9dbd99b9deb19184c063c061f`.
All three authenticated health checks passed. No host database ports were
published. The keyfile initializer exited successfully after installing the
shared server-authentication key with restricted permissions.

## Initial replica set

Replica set `rs0` reached exactly one primary and two secondaries:

- `mongo1:27017` — PRIMARY, health 1, priority 2
- `mongo2:27017` — SECONDARY, health 1, priority 1
- `mongo3:27017` — SECONDARY, health 1, priority 1

All members had one vote. Authentication was required for administrative and
data queries.

## Dataset and majority consistency

The primary inserted 30 deterministic media-project documents, from
`DPRJ-0001` through `DPRJ-0030`. The operation reported `acknowledged: true` and
used `{w: "majority", wtimeout: 10000}`. Authenticated direct reads, including
secondary-preferred reads, returned the same count 30 and identical ordered IDs
from all three members.

MongoDB reported implicit default write concern `majority`, default read concern
`local`, persistent WiredTiger storage, committed-read support, and snapshot
read-concern support. The exercise nevertheless specified majority concern
explicitly for both assessed writes.

## Failover and election

`mongo1` was stopped through the Component 5 Compose project at 07:09:24 UTC.
At the first bounded poll after shutdown, 07:09:28 UTC, `mongo2` reported itself
as writable PRIMARY and `mongo3` remained SECONDARY. The election advanced the
replica-set term from 1 to 2.

The newly elected `mongo2` accepted `DPRJ-0031` with majority write concern and
reported `acknowledged: true`, count 31, and a majority operation time in its
`hello` response.

## Recovery and final state

After restart, former primary `mongo1` rejoined as a healthy SECONDARY. Final
roles were:

- `mongo1:27017` — SECONDARY, health 1
- `mongo2:27017` — PRIMARY, health 1
- `mongo3:27017` — SECONDARY, health 1

Every member returned count 31 and the identical ordered IDs `DPRJ-0001` through
`DPRJ-0031`. All three containers were healthy; the keyfile initializer remained
successfully exited with code 0.

## Preservation checks

Component 4 remained running and healthy with its original 12,350 documents.
PostgreSQL retained counts 500 clients, 10,000 projects, 1,000 staff, 50,000
assignments, 500,000 assets, 5,000 equipment records, and 200,000 reservations.

## Interpretation and limitations

Replication maintained multiple copies and allowed a majority of members to
elect a new primary. Majority writes traded some latency for acknowledgement by
a voting majority. Secondary read preference demonstrated read access to
replicas, but such reads can be stale when replication lags. Writes were briefly
unavailable during election.

This local deployment demonstrates mechanisms used by managed cloud databases,
but it does not demonstrate geographic regions, cloud-provider SLAs, automated
managed backups, elastic scaling, or sharding. All nodes share one Docker host,
so host failure would affect the entire replica set.

## Student reflection

To be written independently after reviewing the raw evidence.

