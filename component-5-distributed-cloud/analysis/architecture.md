# Distributed architecture

Three authenticated MongoDB 8.2.12 members form replica set `rs0` on an internal
Docker network. `mongo1` starts with higher election priority; all members retain
one vote. A shared ignored keyfile authenticates server-to-server replication,
while an ignored root credential authenticates administrative clients.

Majority writes require acknowledgement from a voting majority before success.
Secondary reads demonstrate replicated availability but can be stale depending
on read preference and replication lag. Primary failure triggers an election;
writes pause until a new writable primary gains a majority. This resembles the
replication and automated failover supplied by managed cloud database services,
but this exercise is local and does not demonstrate geographic distribution,
provider SLAs, managed backups, or sharding.

