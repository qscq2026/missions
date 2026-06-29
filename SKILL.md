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

> **Version**: 1.1.0 | **License**: MIT | **Spec**: agentskills.io

## What is Missions?

Missions is a **file-system-driven multi-agent framework** for software engineering. It turns a single AI assistant into a self-managing engineering team with four distinct roles:

- **Orchestrator** — Plans, breaks down goals, and locks validation contracts
- **Worker** — Implements features using TDD with fresh context
- **Validator** — Independently verifies without seeing implementation details
- **PR Author** — Summarizes evidence into human-readable PR descriptions

## When to use this skill

Missions fits when a project has multiple features or milestones, requires TDD and independent validation, and benefits from a persistent audit trail across sessions.

Do **not** use Missions for:
- One-off scripts or quick prototypes (use `/goal` instead)
- Tasks without clear acceptance criteria — Orchestrator needs something concrete to lock into CONTRACT
- Environments without git or file system access (`mv`, `ls`, and `cat` are required)

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

The Orchestrator will ask up to 3 questions in priority order: first to confirm the milestone breakdown, then any technical choices that affect assertion design, then tooling details. Answer them, then **step back** — the agents will handle the rest.

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
7. DETECT active state (authoritative priority order in references/WORKFLOW.md):
    - 03-running/ not empty → Resume Worker
    - 04-review/ not empty → Resume Validator
    - 06-fix/ not empty    → Resume Worker (fix mode)
    - 02-ready/ not empty  → Start Worker on next task
    - 07-pr/ not empty     → STOP, notify human to merge
    - all empty → check 05-done/ via coverage_map → PR Author or new milestone
8. READ .missions/config.yaml (project config)
9. READ .missions/logs/experience/INDEX.md ← CRITICAL
10. READ relevant experiences filtered by detected state/role
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

  CHECK milestone completion:
    - Read CONTRACT.md `coverage_map` block (see AGENTS.md Orchestrator step 4 for required format)
    - List all completed features in 05-done/
    - For each milestone key in coverage_map:
      IF all its feature IDs are present as files in 05-done/ AND not yet in 07-pr/:
        → This milestone is complete (declared by data)
        → Logger generates metrics
        → Experience Curator extracts patterns
        → SWITCH to PR Author role
        → PR Author generates PR-{milestone}.md in 07-pr/
        → Update dashboard: "awaiting human review"
        → STOP loop, notify human

IF mission complete (all milestones done):
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
3. READ specific experience records (top 3 most relevant by category + severity)
4. DOCUMENT in task card: "Experience Applied: [EXP-xxx]"
5. AFTER execution: Update apply_count and last_applied as reference statistics
   (non-atomic — values may drift; relevance selection does not depend on them)
```


## File Structure

```
missions/                          ← skill root (name must match)
├── SKILL.md                       ← this file (entry point)
├── README.md                      ← English documentation
├── README.zh-CN.md                ← Chinese documentation
├── scripts/
│   └── bootstrap.sh               ← optional: environment setup
├── references/
│   ├── AGENTS.md                  ← role protocols (4 + 2 extensible roles)
│   ├── CONFIG.md                  ← configuration guide
│   ├── PRINCIPLE.md               ← design philosophy & deep dive
│   ├── REACTIVATION.md            ← crash recovery & restart protocol
│   ├── WORKFLOW.md                ← state machine reference
│   └── examples/
│       └── experience/            ← sample experience cards
└── assets/
    ├── contract-template.md       ← CONTRACT.md starting structure (Orchestrator)
    ├── feature-template.md        ← task card template
    ├── fix-template.md            ← fix card template
    ├── pr-template.md             ← PR description template
    ├── validation-template.md     ← validation report template
    ├── audit-template.md          ← security/quality audit template
    ├── experience-template.md     ← experience card template
    ├── experience-index-template.md
    ├── metrics-template.md        ← success metrics tracking
    ├── startup-checklist.md       ← project initialization checklist
    ├── diagram-architecture.svg   ← architecture diagram
    └── diagram-state-machine.svg  ← state machine diagram
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
2. **Clarification** — Answer up to 3 questions from Orchestrator (Q1: milestone scope; Q2: assertion-affecting technical choices; Q3: tooling details)
3. **Stuck task** — If a task hangs >20 min, run: `mv .missions/03-running/X.md .missions/02-ready/`
4. **PR merge** — Review the generated PR description, create PR on GitHub, merge, then archive
5. **Review experience** — After mission, review `.missions/logs/experience/` to validate learned patterns
6. **Restart** — Tell the agent to resume (it auto-detects state and loads experience)

### Restarting a Mission

State detection follows the priority order in `references/WORKFLOW.md` — that file is the **single authoritative source**; the Resume Mode summary above is a quick reference only.

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

The full restart protocol, state detection priority, and experience loading sequence are documented in `references/REACTIVATION.md` and `references/WORKFLOW.md`. For log inspection:

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

After each mission completes, the agent reads `logs/experience/` to avoid previously encountered blocking issues, reuse successful patterns, and apply proven fix strategies.
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
