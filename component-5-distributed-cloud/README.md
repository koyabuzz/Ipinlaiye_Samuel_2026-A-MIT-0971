# Component 5: Distributed and Cloud Database Exercise

> Official requirement: “Distributed/cloud database discussion or setup based
> on the same case study, including replication, sharding, availability,
> consistency, or deployment evidence.”

This component implements a local, authenticated three-node MongoDB replica set
for the Media Production and Asset Management case study. It demonstrates
replication, majority consistency, authenticated secondary reads, primary
election, failover availability, and recovery. It is a local distributed
exercise and is **not** represented as a cloud deployment.

The deployment uses the exact ARM64-compatible image `mongo:8.2.12-noble`, an
internal Docker network, unique named volumes, and no published host ports.
Credentials and the replica-set keyfile are Git-ignored.

See `analysis/experiment-instructions.md` for reproducible commands and
`analysis/observed-results.md` for genuine results.


