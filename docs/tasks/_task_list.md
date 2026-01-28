# Task List – Orchestration Spine

This file defines the **mandatory structure and rules** for `docs/tasks/00_task_list.md`.

The task list is the **authoritative orchestration artifact** for the project. It represents the global execution plan and dependency graph.

No execution agent may act on a task unless it is registered here.

---

## Purpose

The task list exists to:

* Provide a single, ordered view of all planned work
* Encode task dependencies explicitly
* Prevent hidden or ad-hoc task creation
* Enable deterministic execution by autonomous agents

This file is **planner-owned** and **planner-maintained**.

---

## Governing Rules (Non-Negotiable)

1. Every executable task **must** appear in this file
2. Task IDs are immutable once created
3. Dependencies must be explicit (no implicit ordering)
4. Tasks may not overlap in scope
5. Tasks may not depend on undocumented work
6. Completion status must reflect reality

If any rule is violated, the task list is invalid.

---

## Task ID Convention

Tasks follow this format:

* `TASK-001`, `TASK-002`, ... (sequential)

Rules:

* IDs are never reused
* IDs are never renumbered
* Deprecated tasks remain listed with status `deprecated`

---

## Status Values

Each task must have exactly one status:

* `planned` – defined but not yet ready for execution
* `ready` – fully specified, executable, artifacts available
* `blocked` – cannot proceed due to unmet dependency
* `in-progress` – currently being executed
* `completed` – executed and verified
* `deprecated` – intentionally abandoned

Only tasks with status `ready` may be executed.

---

## Dependency Semantics

Dependencies must reference **task IDs only**.

Rules:

* A task cannot move to `ready` if any dependency is not `completed`
* Circular dependencies are forbidden
* External dependencies must be called out explicitly (e.g., legal approval)

---

## Structure

The task list must follow this structure exactly.

```markdown
# Task List

## Overview

High-level summary of the planned work and current phase.

## Global Assumptions

Assumptions that apply to the entire task list.

These must be consistent with `CLAUDE.md` and `00_scope.md`.

## Tasks

| ID | Title | Status | Depends On | Task File |
|----|-------|--------|------------|-----------|
| TASK-001 | Example task title | ready | – | task-001.md |
| TASK-002 | Another task | blocked | TASK-001 | task-002.md |

## Notes

Optional planner notes about ordering, phasing, or constraints.
```

---

## Relationship to task-XXX.md

For every row in the task table:

* A corresponding `docs/tasks/task-XXX.md` **must exist**
* The task file defines the full execution contract
* This file defines ordering, readiness, and orchestration

Neither file is sufficient on its own.

---

## Update Rules

The planner must update this file whenever:

* A new task is introduced
* A task is split or merged
* Task status changes
* A task is deprecated

Execution agents must never modify this file.

---

## Validation Checklist (Planner)

Before saving changes, confirm:

* [ ] All tasks have unique IDs
* [ ] All dependencies reference valid task IDs
* [ ] All `ready` tasks have a complete task file
* [ ] No task violates scope constraints
* [ ] Statuses reflect actual project state

If any check fails, stop and fix the issue.

---

## Success Definition

This task list is correct **only if**:

* An execution agent can determine what to work on next
* Without reading any other planning document
* Without guessing dependencies or order

If interpretation is required, the task list has failed.
