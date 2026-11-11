# Distributed and cloud database concepts

Replication copies the same project documents to multiple members. A primary
accepts writes; secondaries continually apply its operation log. Majority write
concern improves consistency and durability by waiting for more than half of the
voting members, at the cost of additional latency and reduced write availability
when a majority is unavailable.

Automatic election improves availability after primary failure, but the system
temporarily cannot accept writes during election. Secondary read preferences can
increase read availability and distribute work, but may return stale data.

Managed cloud services package similar replication with provider-operated
monitoring, patching, backup, scaling, and multi-zone placement. This local
exercise demonstrates the database mechanisms, not a cloud deployment. Sharding
would partition data across shards for horizontal scale, but it is not required
for this assessment and is deliberately omitted.

