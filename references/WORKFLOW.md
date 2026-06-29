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
05-done --[Milestone complete per coverage_map]--> 07-pr (via PR Author)
07-pr --[Human merges]--> 08-merged
```

## Serial Constraint

Only ONE file may exist in `03-running/` at any time. This enforces serial implementation.

## Audit & Experience Flow

```
Every State Transition
    │
    ▼
Logger records:
  - Timestamp
  - From/To state
  - Role, Task, Tokens, Duration
    │
    ▼
Appended to: .missions/logs/audit/YYYY-MM-DD.md

Every Role Completion
    │
    ▼
Logger records:
  - Commands executed
  - Exit codes
  - Files modified
  - Decisions made
    │
    ▼
Appended to: .missions/logs/audit/YYYY-MM-DD.md

Milestone Completion
    │
    ▼
Logger generates:
  - Metrics summary
  - Token usage
  - Fix rate
  - Coverage evolution
    │
    ▼
Written to: .missions/logs/metrics/{mission_id}.yaml

Mission Completion
    │
    ▼
Experience Curator reads audit logs
    │
    ▼
Identifies patterns:
  - Success patterns → .missions/logs/experience/patterns/
  - Anti-patterns → .missions/logs/experience/anti-patterns/
  - Fix strategies → .missions/logs/experience/fixes/
    │
    ▼
Updates: .missions/logs/experience/INDEX.md

Next Mission Start
    │
    ▼
Worker reads:
  - .missions/logs/experience/INDEX.md
  - Relevant category experiences
    │
    ▼
Applies learned patterns
Avoids documented anti-patterns
```

## Self-Improvement Loop

```
┌─────────────────────────────────────────────────────────────┐
│                    Mission N Execution                        │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐        │
│  │Orchestr.│→│ Worker  │→│Validator│→│PR Author│        │
│  └────┬────┘  └────┬────┘  └────┬────┘  └────┬────┘        │
│       │            │            │            │              │
│       └────────────┴────────────┴────────────┘              │
│                      │                                      │
│                      ▼                                      │
│              Logger records all                             │
│                      │                                      │
│                      ▼                                      │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  .missions/logs/audit/2026-06-28.md                  │   │
│  │  .missions/logs/metrics/M1.yaml                      │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│              Experience Curator (Post-Mission)                │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  Extract patterns from audit logs                    │   │
│  │  • What worked? → patterns/                          │   │
│  │  • What failed? → anti-patterns/                   │   │
│  │  • How fixed?   → fixes/                           │   │
│  └─────────────────────────────────────────────────────┘   │
│                              │                              │
│                              ▼                              │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  .missions/logs/experience/INDEX.md                  │   │
│  │  .missions/logs/experience/patterns/tdd-001.md       │   │
│  │  .missions/logs/experience/anti-patterns/auth-001.md │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    Mission N+1 Execution                        │
│  ┌─────────┐                                               │
│  │ Worker  │──► Reads experience before starting            │
│  └────┬────┘                                               │
│       │                                                    │
│       │  "I see EXP-001 says 'always mock DB in tests'"   │
│       │  "I'll apply this pattern from the start"          │
│       │                                                    │
│       ▼                                                    │
│  Faster execution, fewer blocking issues                   │
└─────────────────────────────────────────────────────────────┘
```


## Human Intervention Commands

```bash
# Unstick a task
mv .missions/03-running/stuck.md .missions/02-ready/

# Skip validation (emergency only)
mv .missions/04-review/XXX.md .missions/05-done/XXX.md

# Abandon task
mv .missions/03-running/XXX.md .missions/archive/XXX.md
```


## Restart Protocol

### Detection Flow

```
Agent starts / User says "continue"
    │
    ▼
Read SKILL.md + AGENTS.md
    │
    ▼
Detect state folders
    │
    ├──► 03-running/ not empty ──► Worker was interrupted
    │                                Resume Worker on that task
    │
    ├──► 04-review/ not empty ──► Validator needed
    │                                Resume Validator
    │
    ├──► 06-fix/ not empty ──► Fix needed
    │                             Resume Worker on fix
    │
    ├──► 02-ready/ not empty ──► New tasks available
    │                               Start Worker on next task
    │
    ├──► 07-pr/ not empty ──► Human needs to merge
    │                            STOP, notify human
    │
    └──► All empty ──► Check 05-done/
         │
         ├──► 05-done/ has milestone (verify via CONTRACT.md coverage_map) ──► Trigger PR Author
         │
         └──► 05-done/ empty ──► Mission complete or not started
              │
              ├──► CONTRACT.md exists ──► Mission was interrupted early
              │                            Check 00-orchestrate/
              │
              └──► No CONTRACT ──► Fresh start, run Orchestrator
```

### Experience Reading Flow (MANDATORY)

```
After state detection, BEFORE role execution:
    │
    ▼
Check .missions/logs/experience/INDEX.md
    │
    ├──► EXISTS ──► Read INDEX
    │                 │
    │                 ▼
    │                 Filter by relevance:
    │                   - Same category as current task
    │                   - Same or higher severity
    │                   - Similar task type
    │                 │
    │                 ▼
    │                 Read top 3 relevant experiences
    │                 │
    │                 ▼
    │                 Log to audit: "Applied EXP-xxx: {title}"
    │                 │
    │                 ▼
    │                 Continue with role execution
    │
    └──► NOT EXISTS ──► Log to audit: "No experience found"
                        │
                        ▼
                        Continue with defaults
```

### Restart Commands (Human)

```bash
# Simple restart - agent detects everything
# Just say: "Continue" or "Resume"

# Force restart from specific state
mv .missions/03-running/stuck.md .missions/02-ready/
# Then say: "Continue"

# Check what agent will see on restart
cat .missions/README.md
cat .missions/logs/audit/latest.md

# View experience that will be applied
cat .missions/logs/experience/INDEX.md
```
