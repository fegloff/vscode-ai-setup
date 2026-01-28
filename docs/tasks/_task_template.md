# Task Execution Template

This file defines the **mandatory structure** for any executable task (`task-XXX.md`).

A task file must be **self-sufficient**: an execution agent must be able to complete the task by reading this file and the explicitly listed supporting artifacts only.

---

## Task Metadata

* **Task ID:** task-XXX
* **Title:** Short, action-oriented description
* **Status:** pending | in-progress | blocked | completed
* **Priority:** low | medium | high
* **Created By:** planner
* **Last Updated:** YYYY-MM-DD
* **Related Scope Sections:** (references to `docs/00_scope.md` sections, if applicable)

---

## Task Objective

Clear, concrete statement of what must be achieved.

This section answers:

* What will exist when the task is done?
* How success is verified?

---

## Background & Context

Essential context extracted by the planner from:

* `CLAUDE.md`
* `docs/00_scope.md`
* user inputs

Only include **information strictly necessary** to execute this task.

---

## Functional Requirements

List the functional behaviors to implement.

Use bullet points. Be explicit.

---

## Non-Functional & Architectural Constraints

Mandatory constraints relevant to this task, for example:

* Next.js conventions
* project-wide frontend rules
* performance, security, or maintainability constraints

---

## Supporting Artifacts (Required if applicable)

The following external files are required to execute this task.

If this section is present, the execution agent **may read only these files** in addition to this task file.

If this section is absent or empty, the execution agent **must not read any other project files for context**.

| Path                                    | Type      | Purpose                            | Usage Notes          |
| --------------------------------------- | --------- | ---------------------------------- | -------------------- |
| docs/artifacts/forms/example_form.json  | Data      | Defines form fields and validation | Authoritative source |
| docs/artifacts/assets/sample_report.pdf | Reference | Visual layout reference            | Do not parse text    |

Rules:

* Every artifact must be explicitly listed
* The role of each artifact must be unambiguous
* Parsing vs reference-only usage must be stated

---

## Inputs

Describe inputs required to perform the task:

* user inputs
* API payloads
* configuration values

Include schemas or examples if relevant.

---

## Expected Output

Describe what must be produced:

* files created or modified
* UI behavior
* API responses

Include acceptance criteria when possible.

---

## Implementation Notes

Optional guidance from the planner:

* suggested approach
* pitfalls to avoid
* ordering constraints

This section is advisory, not mandatory.

---

## Validation Checklist

The execution agent must verify:

* [ ] All functional requirements are met
* [ ] Constraints are respected
* [ ] Output matches expectations
* [ ] No undeclared files were used for context

---

## Task History

Chronological log of task execution updates.

* YYYY-MM-DD — status change or note
