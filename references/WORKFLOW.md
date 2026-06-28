# Missions State Machine Reference

## States

| Folder | State | Actor | Action |
|--------|-------|-------|--------|
| 00-orchestrate/ | Planning | Orchestrator | Draft plans |
| 01-contract/ | Locked | Orchestrator | Archive locked contract |
| 02-ready/ | Pending | — | Queue of task cards |
| 03-running/ | Active | Worker | One task being implemented |
| 04-review/ | Reviewing | Validator | Pending validation |
| 05-done/ | Done | — | Completed tasks |
| 06-fix/ | Fixing | Worker | Blocking issues being fixed |
| 07-pr/ | PR Ready | Human | Awaiting human review |
| 08-merged/ | Merged | Human | Archive merged PRs |
| archive/ | History | — | Old task cards |

## Transitions

```
02-ready --[Worker picks up]--> 03-running
03-running --[Worker completes]--> 04-review
04-review --[Validator passes]--> 05-done
04-review --[Validator fails]--> 06-fix + archive
06-fix --[Worker fixes]--> 04-review
05-done --[Milestone complete]--> 07-pr (via PR Author)
07-pr --[Human merges]--> 08-merged
```

## Serial Constraint

Only ONE file may exist in `03-running/` at any time. This enforces serial implementation.

## Human Intervention Commands

```bash
# Unstick a task
mv .missions/03-running/stuck.md .missions/02-ready/

# Skip validation (emergency only)
mv .missions/04-review/XXX.md .missions/05-done/XXX.md

# Abandon task
mv .missions/03-running/XXX.md .missions/archive/XXX.md
```
