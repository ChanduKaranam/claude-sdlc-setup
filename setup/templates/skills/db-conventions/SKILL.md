---
name: db-conventions
description: Use when designing database schemas, writing {{ORM}} models, creating migrations, adding indexes, or working with any database code in {{PROJECT_NAME}}.
---
# DB Conventions — {{PROJECT_NAME}}

## ORM

**{{ORM}} only.** No raw SQL outside of migration files. All queries go through the ORM client.

## Schema ({{SCHEMA_FILE}})

- `{{SCHEMA_FILE}}` is the single source of truth.
- Never edit a committed migration file — create a new one instead.
- Use `{{MIGRATION_CMD}}` to author new migrations.
- Run `{{GENERATE_CMD}}` after every schema change.

## Index discipline

- **Always** index foreign key columns explicitly — the ORM doesn't do this automatically.
- Add composite indexes for common query patterns (e.g. `(workspaceId, createdAt DESC)`).
- Name indexes descriptively: `idx_{table}_{columns}`.

## Multi-tenancy

Every table that stores user data carries a `{{TENANT_ID_FIELD}}` column. All queries filter by it. Never return data across tenant boundaries.

## Soft deletes

For user-created data: `deletedAt DateTime?` (not a boolean). Hard-delete only for system/audit records. Filter `WHERE deletedAt IS NULL` in all list queries.

## Migrations

- Must be reversible. If not possible, document why in the migration file comment.
- Never DROP a column that has data without a data-migration plan.
- Large-table backfills run in batches to avoid lock contention.

## NEVER

- Use raw SQL for application queries — only in migrations.
- Modify a committed migration file.
- Return soft-deleted records to the UI without explicit opt-in.
