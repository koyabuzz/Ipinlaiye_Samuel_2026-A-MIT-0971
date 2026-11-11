# Component 1 validation checklist

Run these checks only after reviewing the draft and creating an isolated project
database.

- [ ] Confirm exactly seven application tables exist.
- [ ] Confirm every table has a generated integer primary key.
- [ ] Confirm every project references an existing client.
- [ ] Confirm assignments reference an existing project and staff member.
- [ ] Confirm one staff member can hold different roles on the same project.
- [ ] Confirm every media asset references a project and has a positive version.
- [ ] Confirm reservations reference valid equipment, projects, and staff.
- [ ] Confirm an inactive staff member cannot make a new reservation.
- [ ] Confirm end dates/times cannot precede their corresponding starts.
- [ ] Confirm negative budgets, sizes, and durations are rejected.
- [ ] Confirm supplied staff emails are unique without regard to letter case.
- [ ] Confirm multiple staff rows may have a `NULL` email.
- [ ] Confirm pending reservations may overlap.
- [ ] Confirm confirmed and checked-out reservations cannot overlap.
- [ ] Confirm back-to-back reservations are allowed.
- [ ] Confirm cancelled or returned reservations do not block a new reservation.
- [ ] Confirm referenced historical records cannot be deleted accidentally.
- [ ] Review the Crow's Foot optionality against the SQL nullability.
- [ ] Record only genuine test output and screenshots as later evidence.

