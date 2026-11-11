# Design rationale and normalisation (Draft)

> This explanation is a review aid, not a final assessed response. Check that
> you can justify each choice in your own words.

## Why the design is normalised

The schema is designed broadly to Third Normal Form (3NF). Each table describes
one kind of thing, and each non-key value describes the row identified by that
table's primary key.

- Client contact information is stored once in `client`, rather than repeated
  in every project.
- Project details are stored in `project`; the client relationship is represented
  by `client_id`.
- Staff details are not copied into projects. `project_assignment` resolves the
  many-to-many relationship and stores facts specific to an assignment, such as
  role and dates. Billing and assignment-hour tracking are outside scope.
- Equipment details are separate from bookings. `equipment_reservation` records
  which project uses an item, who booked it, and when.
- Media metadata is separate from project data. Each asset row represents one
  named version and points to a simulated file location.

This reduces duplication and prevents update anomalies. For example, changing a
client's phone number requires one update, not an update to every project.

## Important constraints

Generated integer identity columns provide stable primary keys. Foreign keys
prevent child records from referring to clients, projects, staff, or equipment
that do not exist. `ON DELETE RESTRICT` supports the decision to retain history;
records that are still referenced cannot be removed casually.

Check constraints reject negative project budgets, invalid date ranges,
non-positive media versions, and unsupported status values. A partial unique
index on `lower(email)` makes supplied staff email addresses case-insensitively
unique while allowing multiple `NULL` values when no email is supplied. Other
unique constraints protect equipment identifiers, file locations, and duplicate
versions of the same named asset within a project.

The reservation exclusion constraint is the main advanced rule. It treats each
booking as a half-open time range: the start is included and the end is excluded.
Therefore, one reservation may start at exactly the time another ends. Ranges for
the same equipment cannot overlap while the rows have `confirmed` or
`checked_out` status. Pending reservations are provisional and do not block a
booking. Returned and cancelled records remain as history but do not block that
time period.

The exclusion rule uses PostgreSQL's supplied `btree_gist` extension. The schema
creates it inside the isolated project database; it does not install additional
macOS software.

## Active staff reservation rule

The approved rule says any **active** staff member may make a reservation. The
foreign key proves that the staff record exists, but a normal `CHECK` constraint
cannot safely inspect another table to confirm `staff.active`. The draft uses a
small trigger for this cross-table rule. It runs when a reservation is inserted
or its `reserved_by` value changes. Deactivating a staff member later does not
erase or invalidate historical reservations.

