# Project Context

This document defines the **foundational technical rules, documentation contracts, and organizational principles**
that govern this Next.js project.

It acts as an **orchestrator**, not as a specification document.

---

## Purpose of This Document

`CLAUDE.md` exists to:

- Establish non-negotiable baseline rules for all Next.js projects
- Define how project knowledge is structured and persisted
- Orchestrate the relationship between scope, planning, and execution artifacts
- Ensure long-term maintainability and consistency across tasks

It does **not** contain:
- Detailed feature specifications
- Business rules or domain logic
- Task-level instructions

Those belong in `docs/`.

---

## Baseline Frontend Engineering Rules (Non-Negotiable)

The following rules apply to **all Next.js projects** created under this system.

### Component Structure and Separation of Concerns

- Each React component must be split by responsibility:
  - `ComponentName.tsx` → logic, state, composition
  - `ComponentName.styles.tsx` → styling only
- Styling must not be inlined inside component logic files.
- Components must remain readable and intentionally scoped.

### Hooks and Server Actions Usage

- Access to Next.js Server Actions must be done via dedicated hooks.
- Components must not call actions directly.
- Hooks act as the interface layer between UI and actions.

### File and Folder Organization

- Files must be organized by feature or domain, not by type.
- Components, hooks, actions, and schemas related to the same feature should live close together.
- Flat structures are preferred over deeply nested hierarchies.

### Code Quality and Maintainability

- Avoid large files; refactor proactively when complexity grows.
- Favor explicitness over clever abstractions.
- Readability and long-term maintenance take precedence over speed.

These rules are assumed by all planning and execution artifacts and are not repeated elsewhere.

---

## Project Knowledge and Source of Truth

All project knowledge must be **persisted as documentation**.

### Authoritative Sources

- `CLAUDE.md` → baseline technical rules and documentation contracts
- `docs/00_scope.md` → scope, phases, assumptions, exclusions
- `docs/01_task_list.md` → planned work and sequencing
- `docs/*.md` → domain knowledge and detailed specifications

The initial user prompt is **not** an authoritative source once documentation exists.

Any critical information introduced via prompts must be:
- Extracted
- Structured
- Persisted into the appropriate document

---

## Documentation as Knowledge Base

The `docs/` directory functions as a **project knowledge base**.

Depending on project complexity, it may include (but is not limited to):

- `02_domain_context.md` — domain rules and concepts
- `03_forms_spec.md` — form flows, fields, and validations
- `04_integrations.md` — external systems and APIs
- `05_non_functionals.md` — performance, security, compliance

Documents must be **referenced, not duplicated**, across the system.

---

## Planning and Execution Artifacts

- `00_scope.md` defines **what** is built and **what is excluded**
- `01_task_list.md` defines **what is planned**
- Execution is driven by focused task briefs (e.g. `active_task.md`)

Execution artifacts must assume:
- Baseline frontend rules apply
- Domain knowledge lives in referenced annexes
- Scope is governed externally

---

## Working Rules

- No silent assumptions
- No undocumented decisions
- No scope expansion without explicit approval
- Baseline rules apply to all tasks unless explicitly overridden
