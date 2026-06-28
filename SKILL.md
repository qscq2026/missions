---
name: missions
description: Multi-agent software engineering framework with role separation, pre-locked validation contracts, and file-system state machine. Use when building production software with multiple features, milestones, or requiring structured code review workflows. Supports TDD enforcement, independent validation, and automated PR generation.
license: MIT
metadata:
  author: Claude Code
  version: "1.0.0"
  category: software-engineering
  tags: [multi-agent, tdd, validation, workflow, state-machine]
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

```
1. READ {baseDir}/SKILL.md (this file)
2. READ {baseDir}/references/AGENTS.md (role protocols)
3. READ {baseDir}/references/CONFIG.md (configuration guide)
4. ASK user for project goal (if not already provided)
5. SWITCH to Orchestrator role
6. EXECUTE Orchestrator workflow from AGENTS.md
7. LOOP: detect state folder → route to role → execute → update state
8. STOP when all state folders are empty
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

You only need to act at these 4 moments:

1. **Start** — Provide the goal (or let the agent infer from project context)
2. **Clarification** — Answer 1-3 questions from Orchestrator
3. **Stuck task** — If a task hangs >20 min, run: `mv .missions/03-running/X.md .missions/02-ready/`
4. **PR merge** — Review the generated PR description, create PR on GitHub, merge, then archive

Everything else is automatic.

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

- **v1.0.0** (2026-06-28): Initial release. Four roles, file-system state machine, PR workflow, agentskills.io compliant.
