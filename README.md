<div align="center">

# 🚀 Missions

**Multi-Agent Software Engineering Framework**

*File-system state machine · Role separation · Pre-locked validation contracts · TDD enforcement*

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Spec](https://img.shields.io/badge/Spec-agentskills.io-blue)](https://agentskills.io)
[![Version](https://img.shields.io/badge/Version-1.1.0-green)]()
[![Platform](https://img.shields.io/badge/Platform-Claude_Code|OpenClaw|Cursor-8A2BE2)]()

</div>

---

## What is Missions?

Missions turns a single AI assistant into a **self-managing engineering team** with four distinct roles:

| Role | Responsibility |
|------|---------------|
| 🧠 **Orchestrator** | Plans, breaks down goals, locks validation contracts |
| 🔧 **Worker** | Implements features using TDD with fresh context each time |
| 🕵️ **Validator** | Independently verifies without seeing implementation details |
| 📝 **PR Author** | Summarizes evidence into human-readable PR descriptions |

> **Core principle**: *"Folders are the state machine. Markdown is the instruction. File moves are the transition."*

---

## Architecture

<div align="center">
  <img src="assets/diagram-architecture.svg" alt="Missions Architecture" width="750">
</div>

---

## State Machine

<div align="center">
  <img src="assets/diagram-state-machine.svg" alt="Missions State Machine" width="750">
</div>

### State Transitions

```
02-ready/     ──[Worker picks up]──▶  03-running/    (Active, max 1 at a time)
03-running/   ──[Worker completes]──▶ 04-review/     (Pending validation)
04-review/    ──[Validator pass]───▶  05-done/       (Completed)
04-review/    ──[Validator fail]───▶  06-fix/ + archive/  (Needs fixing)
06-fix/       ──[Worker fixes]─────▶  04-review/     (Re-enter review)
05-done/      ──[Milestone done]───▶  07-pr/         (PR Author generates PR)
07-pr/        ──[Human merges]─────▶  08-merged/     (Archive)
```

---

## Key Principles

1. **Serial Write, Parallel Read** — File writes and git commits are serial. Research and reading are parallel.
2. **No Long-term Memory** — Agents never rely on conversation history. All context passes through files.
3. **Pre-locked Contracts** — Validation criteria are written **before** any code. No post-hoc test writing.
4. **Absolute Separation** — Worker and Validator are different "personas". Validator never sees Worker reasoning.

---

## Quick Start

### 1. Install

Copy the skill directory into your project:

```bash
# For Claude Code
cp -r missions/ .claude/skills/missions

# For cross-client compatibility
cp -r missions/ .agents/skills/missions
```

### 2. Invoke

In your agent, type `/missions` or describe your goal naturally:

```
I want to build a FastAPI service with OAuth2 login and user management
```

### 3. Answer Clarification Questions

The Orchestrator asks up to 3 questions (e.g., database choice, auth method). Answer them, then **step back** — the agents handle the rest.

### 4. Merge PRs

When the agent reports "PR ready", create the PR on GitHub and merge, then archive:

```bash
mv .missions/07-pr/PR-*.md .missions/08-merged/
```

---

## ✨ New in v1.1

| Feature | Description |
|---------|-------------|
| 🔄 **REACTIVATION Protocol** | Agent crash recovery and session restart — resume interrupted workflows without losing state |
| 🛡️ **Security Auditor Role** | New built-in role for auth/crypto/payment feature reviews |
| 📝 **Context Writer Role** | New extensible role for generating project documentation and knowledge artifacts |
| 📊 **Audit Templates** | Structured security and quality audit report templates |
| 🎯 **Experience System** | Experience cards (templates + index + examples) for capturing lessons learned |
| 📈 **Metrics Tracking** | Quantitative success metrics template for measuring project outcomes |
| ✅ **Startup Checklist** | Project initialization checklist to ensure consistent setup |
| 🚑 **Recovery Sequences** | Enhanced WORKFLOW.md with rollback and restart transition sequences |
| 🧩 **Example Experiences** | EXP-SEED-001/101/201 sample experience cards |

---

## Human Intervention Points

You only need to act at **4 moments**:

| Moment | Action |
|--------|--------|
| 🟢 **Start** | Provide the goal |
| 💬 **Clarification** | Answer 1–3 questions from Orchestrator |
| ⏸️ **Stuck task** | `mv .missions/03-running/X.md .missions/02-ready/` |
| 🔀 **PR merge** | Review PR, create PR on GitHub, merge, archive |

Everything else is **automatic**.

---

## Configuration

Create `.missions/config.yaml` to customize behavior:

```yaml
project:
  name: my-api
  language: python
  framework: fastapi

roles:
  worker:
    enforce_tdd: true
    min_coverage: 80
    allowed_linters: [ruff, mypy]
  validator:
    strict_mode: true
    run_e2e: true
```

### Configuration Hierarchy

```
Built-in defaults (in AGENTS.md)
    │
    ▼ override
config.yaml (skill package default)
    │
    ▼ override
config.local.yaml (user custom, gitignored)
    │
    ▼ override
Environment variables (e.g., MISSIONS_WORKER_MIN_COVERAGE=90)
```

---

## File Structure

### Skill Package

```
missions/                          ← skill root
├── SKILL.md                       ← Entry point + manifest
├── scripts/
│   └── bootstrap.sh               ← Environment setup
├── references/
│   ├── AGENTS.md                  ← Role protocols (4 + 2 extensible roles)
│   ├── CONFIG.md                  ← Configuration guide
│   ├── PRINCIPLE.md               ← Design philosophy
│   ├── REACTIVATION.md            ← Crash recovery & restart protocol
│   ├── WORKFLOW.md                ← State machine + recovery sequences
│   └── examples/
│       └── experience/            ← Sample experience cards
├── assets/
│   ├── feature-template.md        ← Task card template
│   ├── fix-template.md            ← Fix card template
│   ├── pr-template.md             ← PR description template
│   ├── validation-template.md     ← Validation report template
│   ├── audit-template.md          ← Security/quality audit template
│   ├── experience-template.md     ← Experience card template
│   ├── experience-index-template.md
│   ├── metrics-template.md        ← Success metrics tracking
│   └── startup-checklist.md       ← Project initialization checklist
└── README.md                      ← This file
```

### Runtime (Generated by Agent)

```
.missions/                         ← Created in your project
├── config.yaml                    ← User configuration
├── AGENTS.md                      ← Role protocols (copied)
├── CONTRACT.md                    ← Locked validation contract
├── README.md                      ← Live status dashboard
├── 00-orchestrate/                ← Planning drafts
├── 01-contract/                   ← Locked contract archive
├── 02-ready/                      ← Pending task cards
├── 03-running/                    ← Active task (max 1)
├── 04-review/                     ← Pending validation
├── 05-done/                       ← Completed tasks
├── 06-fix/                        ← Pending fixes
├── 07-pr/                         ← PR descriptions
├── 08-merged/                     ← Merged PRs
└── archive/                       ← Historical records
```

---

## Progressive Disclosure

Follows the [agentskills.io](https://agentskills.io) specification — keeping the agent's baseline context lean:

| Level | Content | Size | When Loaded |
|-------|---------|------|-------------|
| 1 | `name` + `description` | ~100 tokens | At startup |
| 2 | SKILL.md body | ~3000 tokens | On skill activation |
| 3 | `references/*.md`, `assets/*.md` | Variable | On demand per role |

---

## Customization Levels

| Level | Action | Difficulty |
|-------|--------|-----------|
| 1 | Edit `config.yaml` | ⭐ Easy |
| 2 | Override templates in `assets/` | ⭐⭐ Medium |
| 3 | Add custom roles in `AGENTS.md` | ⭐⭐⭐ Advanced |
| 4 | Add lifecycle hooks in `scripts/` | ⭐⭐⭐ Advanced |
| 5 | Modify state machine in `WORKFLOW.md` | ⭐⭐⭐⭐ Expert |

---

## Cross-Platform Compatibility

| Platform | Support | Invocation |
|----------|---------|------------|
| [Claude Code](https://docs.anthropic.com/en/docs/claude-code/overview) | ✅ Native | `/missions` or auto-detect |
| [OpenClaw](https://github.com/openclaw) | ✅ Native | `openclaw skill install missions` |
| Cursor Agent | ✅ Compatible | Copy `.claude/skills/missions/` to project |
| VS Code + Continue | ✅ Compatible | Custom prompt loading |
| GitHub Copilot Chat | ⚠️ Partial | Manual template copy |

---

## Troubleshooting

| Symptom | Cause | Fix |
|---------|-------|-----|
| Agent doesn't auto-route | SKILL.md not loaded | Ensure skill is in `.claude/skills/missions/` or invoke `/missions` |
| CONTRACT not locked | Orchestrator didn't finish | Answer all clarification questions |
| Worker stuck | Task too large | Reduce `max_lines_per_feature` in config |
| Validator misses issues | `strict_mode` off | Set `roles.validator.strict_mode: true` |
| No PR generated | Milestone incomplete | Wait for all features in `05-done/` |

---

## Design Philosophy

Missions is not about making agents smarter. It's about making them **accountable** — every decision, every test, every bug fix is recorded in a structured, auditable file.

> **"Configuration is code. Templates are protocols. Hooks are extensions."**
>
> — Missions Skill Design Philosophy

### Comparison: Original vs agentskills.io Version

| Dimension | Original Missions | Missions Skill (v1.1) |
|-----------|------------------|-----------------------|
| Spec | None | ✅ **agentskills.io** compliant |
| Config | None | ✅ **config.yaml** driven |
| Templates | Hardcoded | ✅ **Overridable** assets/ (10 templates) |
| Roles | 3 fixed | ✅ **4 + 2 extensible** (security-auditor, context-writer) |
| Hooks | None | ✅ **scripts/** lifecycle |
| Recovery | None | ✅ **REACTIVATION.md** crash recovery protocol |
| Experience | None | ✅ **Experience system** (cards + index + examples) |
| Cross-platform | Claude Code only | ✅ **Multi-platform** |
| Progressive disclosure | None | ✅ **3-level loading** |

---

## License

[MIT](LICENSE)

## Changelog

- **v1.1.0** (2026-06-29): New agent protocol. Added REACTIVATION.md crash recovery,
  audit/experience/metrics/startup templates, security-auditor and context-writer roles,
  enhanced WORKFLOW.md with recovery/restart sequences, example experiences.
- **v1.0.0** (2026-06-28): Initial release. Four roles, file-system state machine, PR workflow, agentskills.io compliant.
