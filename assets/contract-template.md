---
status: locked
version: "1.0"
locked_at: {{locked_at}}
locked_by: Orchestrator
---

# CONTRACT: {{project_name}}

> This file is IMMUTABLE after locking. No role may modify it.
> Written once by Orchestrator; read by all roles throughout the mission.

## Global Constraints

<!--
List project-wide invariants that ALL features must satisfy.
Examples: "All APIs return JSON", "Coverage ≥ 80%", "No synchronous I/O in handlers"
-->

| ID | Constraint | Rationale |
|----|-----------|-----------|
| GC-01 | {{constraint_description}} | {{rationale}} |

## Behavioral Assertions

<!--
Each assertion = one verifiable claim about system behavior.
Tool: the command that proves or disproves the assertion.
Evidence: what passing output looks like.
-->

| ID | Behavior | Tool | Evidence |
|----|---------|------|---------|
| A-01 | {{behavior_description}} | `{{test_command}}` | {{expected_output}} |

## Coverage Map

<!--
REQUIRED. Maps each milestone to its feature IDs.
Milestone completion detection (PR Author trigger) reads this block.
Format must be preserved exactly — do not nest or rename keys.
-->

```yaml
coverage_map:
  M1:
    - F-001
    - F-002
  M2:
    - F-003
```

## Milestone Definitions

| Milestone | Title | Features | Goal |
|-----------|-------|---------|------|
| M1 | {{milestone_title}} | F-001, F-002 | {{milestone_goal}} |

## Immutability Log

| Timestamp | Event |
|-----------|-------|
| {{locked_at}} | CONTRACT locked by Orchestrator |
