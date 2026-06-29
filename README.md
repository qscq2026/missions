<div align="center">

# 🚀 Missions

**Multi-Agent Software Engineering Framework**

*File-system state machine · Role separation · Pre-locked validation contracts · TDD enforcement*

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Spec](https://img.shields.io/badge/Spec-agentskills.io-blue)](https://agentskills.io)
[![Version](https://img.shields.io/badge/Version-2.0.0-green)]()
[![Platform](https://img.shields.io/badge/Platform-Claude_Code|OpenClaw|Cursor-8A2BE2)]()

</div>

---

## What is Missions?

Missions turns a single AI assistant into a **self-managing engineering team** with four distinct roles:

| Role | Responsibility |
|------|---------------|
| 🧠 **Orchestrator** | Plans, breaks down goals, locks validation contracts |
| 🔧 **Worker** | Implements features using TDD with file-scoped context — no cross-role reasoning leaks |
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
5. **Experience Pre-Load** — Every role loads relevant historical experiences before executing any task, preventing repeated mistakes and reusing proven patterns, filtered by detected role and task type.
6. **Self-Improvement Loop** — After each mission, the agent reviews logged experiences to continuously improve: avoid past blockers, reuse successful patterns, optimize token usage.

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

The Orchestrator asks up to 3 questions in priority order: first to confirm the milestone breakdown, then technical choices that affect assertion design, then tooling details. Answer them, then **step back** — the agents handle the rest.

### 4. Merge PRs

When the agent reports "PR ready", create the PR on GitHub and merge, then archive:

```bash
mv .missions/07-pr/PR-*.md .missions/08-merged/
```

---

## ✨ What's New

### v2.0 Highlights

| Feature | Description |
|---------|-------------|
| 🎯 **Coverage Map Milestone Detection** | PR Author triggers via `coverage_map` key→feature-ID matching — no false positives |
| 🧩 **Priority-Ordered Clarification** | Orchestrator questions follow strict priority: Q1 milestone scope → Q2 assertion impact → Q3 tooling details |
| 🧹 **File-Scoped Worker Context** | Worker uses file-scoped context instead of "fresh start" — reads only its own protocol and relevant files |
| 📋 **Contract Template** | New `assets/contract-template.md` gives Orchestrator a starting structure for CONTRACT.md |
| 🔗 **Hierarchical Fix Tracking** | Fix cards now track `root_feature` + `fix_number` — audit chain integrity across multiple fix rounds |
| ⚡ **Optimized Restart Sequence** | State detection moved before config/experience loading — experiences filtered by detected role |
| 🧠 **Smarter Experience Curation** | Critical issues recorded on first occurrence; major/minor require ≥2 occurrences before recording |
| 🚀 **Auto-Seed Bootstrap** | `bootstrap.sh` automatically copies seed experiences and contract template on project init |

### Previously in v1.1

| Feature | Description |
|---------|-------------|
| 🔄 **REACTIVATION Protocol** | Agent crash recovery and session restart |
| 🛡️ **Security Auditor Role** | Built-in role for security-sensitive feature reviews |
| 📝 **Context Writer Role** | Extensible role for documentation and knowledge artifacts |
| 📊 **Audit Templates** | Structured security and quality audit report templates |
| 🎯 **Experience System** | Experience cards (templates + index + examples) for lessons learned |
| 📈 **Metrics Tracking** | Quantitative success metrics template |
| ✅ **Startup Checklist** | Project initialization checklist |

---

## Human Intervention Points

You only need to act at **6 moments**:

| Moment | Action |
|--------|--------|
| 🟢 **Start** | Provide the goal |
| 💬 **Clarification** | Answer 1–3 questions from Orchestrator |
| ⏸️ **Stuck task** | `mv .missions/03-running/X.md .missions/02-ready/` |
| 🔀 **PR merge** | Review PR, create PR on GitHub, merge, archive |
| 📖 **Review experience** | After mission, check `.missions/logs/experience/` to validate learned patterns |
| 🔄 **Restart** | Just tell the agent to resume — it auto-detects state and loads experience |

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
│   ├── contract-template.md        ← CONTRACT.md starting structure
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
├── logs/                          ← Audit trail & learning
│   ├── audit/*.md                 ← Execution history
│   ├── metrics/*.yaml             ← Performance data
│   └── experience/*.md            ← Learned patterns (INDEX.md + cards)
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
| No PR generated | Milestone not complete per `coverage_map` | Verify all feature IDs for the milestone exist in `05-done/` |

---

## Restarting a Mission

The agent can **auto-resume** interrupted missions — no manual re-initialization needed.

```bash
# Just tell the agent:
/resume
# Or describe what to continue:
Continue the worker task that was in progress
```

The agent will automatically:
1. Detect existing `.missions/` state **(first step — before reading config or experience)**
2. Read `.missions/config.yaml` for project settings
3. Read `.missions/logs/experience/INDEX.md` for historical context
4. Filter experiences by the **detected role** (Worker/Validator/Fix) and task type — only the most relevant 3 are loaded
5. Read `.missions/03-running/*.md` (if any) to recover partial task context
6. Continue from where it left off, with experience applied

```bash
# View experience that will be applied
cat .missions/logs/experience/INDEX.md
```

### What NOT to Do on Restart

- ❌ Do **not** re-run `/missions` — this triggers fresh initialization
- ❌ Do **not** manually re-lock CONTRACT.md — it's immutable after lock
- ❌ Do **not** move files between state folders — let the agent handle transitions

---

## Audit & Experience

Missions features a structured learning system:

### Audit Trail

Every role execution is logged to `.missions/logs/audit/`:

```bash
# View latest audit entry
cat .missions/logs/audit/latest.md
```

### Experience System

The experience system captures lessons learned and reusable patterns:

- **Experience cards** — Structured markdown files in `.missions/logs/experience/`
- **INDEX.md** — Searchable index of all experiences with severity, category, and relevance tags
- **Pre-load** — Every role automatically reads relevant experiences before executing any task
- **Self-improvement** — After each mission, the agent reviews experiences to avoid past blockers and reuse successful patterns

### Self-Improvement Loop

After each mission completes, the agent reads `logs/experience/` to:
- Avoid previously encountered blocking issues
- Reuse successful implementation patterns
- Apply proven fix strategies
- Optimize token usage based on historical data

---

## Design Philosophy

Missions is not about making agents smarter. It's about making them **accountable** — every decision, every test, every bug fix is recorded in a structured, auditable file.

> **"Configuration is code. Templates are protocols. Hooks are extensions."**
>
> — Missions Skill Design Philosophy

### Comparison: Original vs agentskills.io Version

| Dimension | Original Missions | Missions Skill (v2.0) |
|-----------|------------------|-----------------------|
| Spec | None | ✅ **agentskills.io** compliant |
| Config | None | ✅ **config.yaml** driven |
| Templates | Hardcoded | ✅ **Overridable** assets/ (11 templates incl. contract-template) |
| Roles | 3 fixed | ✅ **4 + 2 extensible** (security-auditor, context-writer) |
| Hooks | None | ✅ **scripts/** lifecycle |
| Milestone Detection | Manual | ✅ **coverage_map** automatic detection |
| Recovery | None | ✅ **REACTIVATION.md** crash recovery protocol |
| Experience | None | ✅ **Experience system** (cards + index + examples) |
| Experience Curation | Record all | ✅ **Severity-thresholded** (critical→immediate, major/minor→≥2 occurrences) |
| Fix Tracking | Flat parent ID | ✅ **Hierarchical** (root_feature + fix_number + immediate parent) |
| Worker Context | "Fresh start" | ✅ **File-scoped context** (reads only role protocol + relevant files) |
| Clarification Order | Arbitrary | ✅ **Priority-ordered** (Q1 milestone → Q2 assertion → Q3 tooling) |
| Restart Sequence | Config→experience→detect | ✅ **Detect→config→role-filtered experience** |
| Cross-platform | Claude Code only | ✅ **Multi-platform** |
| Progressive disclosure | None | ✅ **3-level loading** |

---

## License

[MIT](LICENSE)

## Changelog

- **v2.0.0** (2026-06-30): Claude修订版. State detection moved before config/experience reading (role-filtered). PR Author triggers via `coverage_map` key→feature-ID matching. Orchestrator questions priority-ordered (Q1: milestone scope → Q2: assertion impact → Q3: tooling details). Worker "Fresh start" → "File-scoped context". New `assets/contract-template.md`. Fix card template with `root_feature`/`fix_number`/hierarchical parent tracking. Restart section extracted from SKILL.md into REACTIVATION.md. Experience Curator severity thresholds: critical→record first occurrence, major/minor→require ≥2. `bootstrap.sh` auto-seeds experiences and contract template.
- **v1.1.0** (2026-06-29): New agent protocol. Added REACTIVATION.md crash recovery,
  audit/experience/metrics/startup templates, security-auditor and context-writer roles,
  enhanced WORKFLOW.md with recovery/restart sequences, example experiences.
- **v1.0.0** (2026-06-28): Initial release. Four roles, file-system state machine, PR workflow, agentskills.io compliant.
