# Relational and document-model comparison

PostgreSQL stores each subject once and links normalized tables with foreign
keys. This provides strong referential integrity, expressive joins, and the GiST
exclusion rule used for reservation concurrency. It is suitable for structured
operational records and rules spanning multiple entities.

MongoDB can return a project, client snapshot, schedule, tags, and crew in one
document. Flexible nested structures fit varying media metadata and reduce joins
for project-centred reads. Separate asset and reservation collections prevent
unbounded project growth.

Embedding duplicates selected values. Snapshot changes do not automatically
follow the authoritative staff, equipment, or project document. MongoDB has no
built-in foreign keys, so the loader and verification scripts must check
references explicitly. Large or unbounded arrays cause document growth and must
be separated. MongoDB is appropriate when access patterns favour aggregate
documents and evolving metadata; PostgreSQL remains stronger where cross-entity
consistency and relational constraints dominate.

