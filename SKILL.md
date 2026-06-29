---
name: missions
description: Multi-agent software engineering framework with role separation, pre-locked validation contracts, and file-system state machine. Use when building production software with multiple features, milestones, or requiring structured code review workflows. Supports TDD enforcement, independent validation, and automated PR generation.
license: MIT
metadata:
  author: Claude Code
  version: "1.1.0"
  category: software-engineering
  tags: [multi-agent, tdd, validation, workflow, state-machine, audit, self-improvement]
  min_agent_version: "0.1.0"
compatibility: Designed for Claude Code and any agentskills.io-compatible agent. Requires git and a Unix-like file system (ls, mv, cat).
---

# Missions — Multi-Agent Software Engineering Framework

> **Version**: 1.0.0 | **License**: MIT | **Spec**: agentskills.io

## What is Missions?

Missions is a **file-system-driven multi-agent framework** for software engineering. It turns a single AI assistant into a self-managing engineering team with four distinct roles:

- **Orchestrator** — Plans, breaks down goals, and locks validation contracts
- **Worker** — Implements features using TDD with fresh context
- **Validator** — Independently verifies without seeing implementation details
- **PR Author** — Summarizes evidence into human-readable PR descriptions

## When to use this skill

Use Missions when:
- Building a project with **multiple features or milestones**
- You want **TDD enforced** and **independent code review**
- You need **audit trails** of every decision (Handoffs, Validation Reports)
- You want **minimal human intervention** — just answer clarification questions and merge PRs
- Working on **long-running tasks** where context dilution is a risk

Do **not** use Missions for:
- One-off scripts or quick prototypes (use `/goal` instead)
- Tasks without clear acceptance criteria
- Environments without git or file system access

## Quick Start

### 1. Install

Copy this skill directory into your project:

```bash
# For Claude Code
cp -r missions/ .claude/skills/missions

# For cross-client compatibility
cp -r missions/ .agents/skills/missions
```

### 2. Invoke

In your agent, type:

```
/missions
```

Or describe your goal naturally:

```
I want to build a FastAPI service with OAuth2 login and user management
```

The agent will automatically load this skill if the task matches the description.

### 3. Answer Clarification Questions

The Orchestrator will ask up to 3 questions (e.g., database choice, auth method). Answer them, then **step back** — the agents will handle the rest.

### 4. Merge PRs

When the agent reports "PR ready", copy the generated `07-pr/PR-*.md` into GitHub and merge. Then run:

```bash
mv .missions/07-pr/PR-*.md .missions/08-merged/
```

## How It Works

### State Machine (Folders as States)

```
02-ready/     → Worker picks up (mv to 03-running/)
03-running/   → Worker implements (mv to 04-review/)
04-review/    → Validator checks (mv to 05-done/ or 06-fix/)
05-done/      → PR Author generates PR (mv to 07-pr/)
06-fix/       → Worker fixes (mv back to 04-review/)
07-pr/        → Human reviews and merges (mv to 08-merged/)
08-merged/    → Archive
```

### Key Principles

1. **Serial Write, Parallel Read**: File writes and git commits are serial. Research and reading are parallel.
2. **No Long-term Memory**: Agents never rely on conversation history. All context passes through files.
3. **Pre-locked Contracts**: Validation criteria are written **before** any code. No post-hoc test writing.
4. **Absolute Separation**: Worker and Validator are different "personas". Validator never sees Worker reasoning.

## Boot Sequence (For Agents)

> If you are an agent reading this, execute the following:

### Phase 0: Resume Detection

```
1. READ {baseDir}/SKILL.md (this file)
2. CHECK: Does .missions/ exist?
3. IF YES → RESUME MODE (see below)
4. IF NO  → FRESH START MODE (see below)
```

### Resume Mode (Existing Project)

```
5. READ {baseDir}/references/REACTIVATION.md (reactivation protocol)
6. READ .missions/README.md (current status)
7. READ .missions/config.yaml (project config)
8. READ .missions/logs/experience/INDEX.md (historical knowledge) ← CRITICAL
9. READ relevant experiences based on detected state
10. DETECT active state:
    - 03-running/ → Resume Worker
    - 04-review/ → Resume Validator
    - 06-fix/ → Resume Worker (fix mode)
    - 02-ready/ → Start Worker on next task
    - 05-done/ + others empty → PR Author or new milestone
    - all empty → Ask user for next milestone
11. RESUME execution from detected state
```

### Fresh Start Mode (New Project)

```
5. READ {baseDir}/references/AGENTS.md (role protocols)
6. READ {baseDir}/references/CONFIG.md (configuration guide)
7. RUN {baseDir}/scripts/bootstrap.sh
8. CREATE default .missions/config.yaml
9. ASK user for project goal
10. SWITCH to Orchestrator role
11. EXECUTE Orchestrator workflow
```

### Main Execution Loop (Both Modes)

```
LOOP:
  a. Logger records state transition
  b. Detect state folder → route to role
  c. Role reads relevant experiences BEFORE executing ← CRITICAL
  d. Role executes
  e. Role documents applied experiences in Handoff
  f. Logger records role completion
  g. Update state

IF milestone complete:
  - Logger generates metrics
  - Experience Curator extracts patterns

IF mission complete:
  - Logger generates audit summary
  - Experience Curator updates INDEX.md
  - STOP
```

### Experience Pre-Load (Every Role, Every Task)

Before executing ANY task, the active role MUST:

```
1. READ .missions/logs/experience/INDEX.md
2. IDENTIFY relevant categories:
   Worker → patterns/tdd-*, patterns/architecture-*, fixes/*
   Validator → anti-patterns/validation-*, patterns/testing-*
   Orchestrator → patterns/planning-*, anti-patterns/scope-*
3. READ specific experience records (top 3 most relevant)
4. DOCUMENT in task card: "Experience Applied: [EXP-xxx]"
5. AFTER execution: Update apply_count and last_applied
```


## File Structure

```
missions/                          ← skill root (name must match)
├── SKILL.md                       ← this file (entry point)
├── scripts/
│   └── bootstrap.sh               ← optional: environment setup
├── references/
│   ├── AGENTS.md                  ← role protocols (Orchestrator/Worker/Validator/PR Author)
│   ├── CONFIG.md                  ← configuration guide
│   ├── PRINCIPLE.md               ← design philosophy & deep dive
│   └── WORKFLOW.md                ← state machine reference
└── assets/
    ├── feature-template.md        ← task card template
    ├── fix-template.md            ← fix card template
    ├── pr-template.md             ← PR description template
    └── validation-template.md     ← validation report template
```

## Runtime Structure (Created by Agent)

After the skill runs, your project will have:

```
.missions/                         ← runtime working directory
├── logs/                          ← ← ← 审计日志（自动追加）
│   ├── audit/                     ← 每次 Agent 执行的完整记录
│   ├── metrics/                   ← 量化指标（token、时间、成功率）
│   └── experience/                ← ← ← 经验库（用于自我改进）
│       ├── patterns/              ← 成功模式
│       ├── anti-patterns/         ← 失败教训
│       └── fixes/                 ← 修复方案复用
├── config.yaml                    ← user configuration (customize this)
├── AGENTS.md                      ← runtime role protocols (copied from skill)
├── CONTRACT.md                    ← locked validation contract (generated by Orchestrator)
├── README.md                      ← live status dashboard (auto-updated)
├── 00-orchestrate/                ← planning drafts
├── 01-contract/                 ← locked contract archive
├── 02-ready/                      ← pending task cards
├── 03-running/                    ← active task (serial, max 1)
├── 04-review/                     ← pending validation
├── 05-done/                       ← completed tasks
├── 06-fix/                        ← pending fixes
├── 07-pr/                         ← PR descriptions (human action needed)
├── 08-merged/                     ← merged PRs
└── archive/                       ← historical records
```

## Configuration

Create `.missions/config.yaml` to customize behavior. See `references/CONFIG.md` for full options.

**Minimal example:**

```yaml
project:
  name: my-api
  language: python
  framework: fastapi

roles:
  worker:
    enforce_tdd: true
    min_coverage: 80
```

## Progressive Disclosure

This skill follows agentskills.io progressive disclosure:

- **Level 1** (~100 tokens): `name` + `description` loaded at startup
- **Level 2** (~3000 tokens): This `SKILL.md` body loaded when skill activates
- **Level 3** (on demand): `references/AGENTS.md`, `references/CONFIG.md`, templates in `assets/`

Keep `SKILL.md` under 500 lines. Detailed reference material lives in `references/`.

## Human Intervention Points

You only need to act at these 6 moments:

1. **Start** — Provide the goal (or let the agent infer from project context)
2. **Clarification** — Answer 1-3 questions from Orchestrator
3. **Stuck task** — If a task hangs >20 min, run: `mv .missions/03-running/X.md .missions/02-ready/`
4. **PR merge** — Review the generated PR description, create PR on GitHub, merge, then archive
5. **Review experience** — After mission, review `.missions/logs/experience/` to validate learned patterns
6. **Restart** — Tell the agent to resume (it auto-detects state and loads experience)

### Restarting a Mission

```bash
# Agent will auto-detect and resume. Just say:
# "Resume the mission"
# "Continue from where we left off"
# "Start milestone M2"

# Check current status before restarting
cat .missions/README.md

# View what was happening
cat .missions/logs/audit/$(date +%Y-%m-%d).md

# View experience that will be applied
cat .missions/logs/experience/INDEX.md
```

### Viewing Audit Logs

```bash
# Today's execution
cat .missions/logs/audit/$(date +%Y-%m-%d).md

# Mission summary
cat .missions/logs/audit/summary.md

# Metrics
cat .missions/logs/metrics/summary.yaml

# Experience library
cat .missions/logs/experience/INDEX.md
```

Everything else is automatic.

## Audit & Experience
## Restarting a Mission

### When to Restart

Restart when:
- Previous session was interrupted (power loss, timeout, window closed)
- You want to continue from where you left off
- New day, same project
- Agent lost context

### Restart Sequence

```
1. READ {baseDir}/SKILL.md (this file)
2. READ {baseDir}/references/AGENTS.md (all roles)
3. READ {baseDir}/references/WORKFLOW.md (state machine rules)
4. DETECT current state:
   a. List all state folders (02-ready/, 03-running/, etc.)
   b. Read .missions/README.md for current status
   c. Read .missions/logs/audit/latest.md for context
5. IF experience exists:
   a. READ .missions/logs/experience/INDEX.md
   b. READ relevant experiences for current task type
6. ROUTE to appropriate role based on detected state
7. CONTINUE execution from detected state
```

### State Detection Priority

```bash
# Check in this order (highest priority first):
ls .missions/03-running/    # If not empty → Worker was interrupted
ls .missions/04-review/     # If not empty → Validator needed
ls .missions/06-fix/        # If not empty → Fix needed
ls .missions/02-ready/      # If not empty → New task available
ls .missions/07-pr/         # If not empty → Human needs to merge
ls .missions/05-done/       # If not empty → Check if milestone complete
```

### Experience Loading on Restart

When restarting, the agent MUST:

1. **Check for experience**: `ls .missions/logs/experience/`
2. **If experience exists**:
   - Read `INDEX.md` to understand available knowledge
   - Filter experiences by **relevance** to current task:
     - Same category (tdd, validation, architecture)
     - Same severity (critical, major)
     - Similar task type (auth, api, database)
   - Read top 3 most relevant experiences
   - Apply lessons before starting work

3. **If no experience**: Proceed with defaults from AGENTS.md

### Example Restart Flow

```
User: "Continue from yesterday"

Agent:
  1. Detect: 03-running/F-003.md exists
  2. Read: F-003.md handoff (partially complete)
  3. Read: experience/INDEX.md
  4. Find: EXP-SEED-001 (Mock External Dependencies)
  5. Apply: "I see previous missions learned to mock DB. 
             I'll apply this pattern for F-003."
  6. Continue: Worker role, pick up F-003 from where left off
```

### Persistent State Files

These files survive restarts and provide continuity:

| File | Purpose | Updated By |
|------|---------|-----------|
| `README.md` | Live status dashboard | All roles |
| `CONTRACT.md` | Locked validation criteria | Orchestrator (once) |
| `logs/audit/*.md` | Execution history | Logger |
| `logs/metrics/*.yaml` | Performance data | Logger |
| `logs/experience/*.md` | Learned patterns | Experience Curator |
| `05-done/*.md` | Completed tasks | Validator |
| `08-merged/*.md` | Merged PRs | Human |

### What NOT to Do on Restart

- Do NOT start a new mission if state folders are not empty
- Do NOT ignore partially completed tasks in `03-running/`
- Do NOT skip reading experience if it exists
- Do NOT ask clarification questions again (CONTRACT is already locked)
- Do NOT re-generate task cards that already exist in `02-ready/`


### Viewing Logs

```bash
# 查看最近执行记录
cat .missions/logs/audit/2026-06-28.md

# 查看成功率统计
cat .missions/logs/metrics/summary.yaml

# 查看经验库
cat .missions/logs/experience/patterns/tdd-success.md
```

### Self-Improvement Loop

After each mission completes, the agent reads `logs/experience/` to:
- Avoid previously encountered blocking issues
- Reuse successful implementation patterns
- Apply proven fix strategies
- Optimize token usage based on historical data

## Troubleshooting

| Symptom | Cause | Fix |
|---------|-------|-----|
| Agent doesn't auto-route | SKILL.md not loaded | Ensure skill is in `.claude/skills/missions/` or invoke `/missions` |
| CONTRACT not locked | Orchestrator didn't finish | Answer all clarification questions |
| Worker stuck | Task too large | Reduce `max_lines_per_feature` in config |
| Validator misses issues | strict_mode off | Set `roles.validator.strict_mode: true` |
| No PR generated | Milestone incomplete | Wait for all features in `05-done/` |

## Design Philosophy

> **"Folders are the state machine. Markdown is the instruction. File moves are the transition."**

Missions is not about making agents smarter. It's about making them **accountable** — every decision, every test, every bug fix is recorded in a structured, auditable file.

## References

- [Role Protocols](references/AGENTS.md) — Detailed responsibilities for each role
- [Configuration Guide](references/CONFIG.md) — How to customize with config.yaml
- [Design Principles](references/PRINCIPLE.md) — Why this architecture exists
- [State Machine Reference](references/WORKFLOW.md) — Complete state transitions

## Changelog

- **v1.1.0** (2026-06-29): New agent protocol. Added REACTIVATION.md, audit/experience/metrics templates, startup checklist, example experiences (EXP-SEED-001/101/201), expanded AGENTS.md with security-auditor and context-writer roles, enhanced WORKFLOW.md with recovery and restart sequences.
- **v1.0.0** (2026-06-28): Initial release. Four roles, file-system state machine, PR workflow, agentskills.io compliant.
