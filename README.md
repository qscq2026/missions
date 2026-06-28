<div align="center">

# 🚀 Missions

**Multi-Agent Software Engineering Framework**

*File-system state machine · Role separation · Pre-locked validation contracts · TDD enforcement*

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Spec](https://img.shields.io/badge/Spec-agentskills.io-blue)](https://agentskills.io)
[![Version](https://img.shields.io/badge/Version-1.0.0-green)]()
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
<svg width="750" height="380" viewBox="0 0 750 380" xmlns="http://www.w3.org/2000/svg">
  <style>
    text { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif; }
    .box { rx: 8; ry: 8; }
    .arrow { stroke: #888; stroke-width: 2; fill: none; marker-end: url(#arrow); }
  </style>
  <defs>
    <marker id="arrow" markerWidth="10" markerHeight="7" refX="9" refY="3.5" orient="auto">
      <polygon points="0 0, 10 3.5, 0 7" fill="#888"/>
    </marker>
  </defs>

  <!-- User -->
  <rect x="275" y="10" width="200" height="42" class="box" fill="#1a1a2e"/>
  <text x="375" y="37" text-anchor="middle" fill="#fff" font-size="14" font-weight="bold">👤 User / Human PM</text>

  <line x1="375" y1="52" x2="375" y2="75" class="arrow"/>

  <!-- SKILL.md -->
  <rect x="225" y="78" width="300" height="42" class="box" fill="#e94560"/>
  <text x="375" y="105" text-anchor="middle" fill="#fff" font-size="14" font-weight="bold">📋 SKILL.md — Entry Point</text>

  <line x1="247" y1="120" x2="120" y2="155" class="arrow"/>
  <line x1="375" y1="120" x2="375" y2="155" class="arrow"/>
  <line x1="502" y1="120" x2="630" y2="155" class="arrow"/>

  <!-- Three pillars -->
  <rect x="20" y="158" width="200" height="60" class="box" fill="#16213e"/>
  <text x="120" y="184" text-anchor="middle" fill="#fff" font-size="13" font-weight="bold">⚙️ scripts/</text>
  <text x="120" y="204" text-anchor="middle" fill="#aaa" font-size="11">Lifecycle hooks</text>

  <rect x="275" y="158" width="200" height="60" class="box" fill="#0f3460"/>
  <text x="375" y="184" text-anchor="middle" fill="#fff" font-size="13" font-weight="bold">📜 references/</text>
  <text x="375" y="204" text-anchor="middle" fill="#aaa" font-size="11">Role protocols · Config · Design</text>

  <rect x="530" y="158" width="200" height="60" class="box" fill="#533483"/>
  <text x="630" y="184" text-anchor="middle" fill="#fff" font-size="13" font-weight="bold">📋 assets/</text>
  <text x="630" y="204" text-anchor="middle" fill="#aaa" font-size="11">Task cards · PR · Validation</text>

  <line x1="120" y1="218" x2="375" y2="258" class="arrow"/>
  <line x1="375" y1="218" x2="375" y2="258" class="arrow"/>
  <line x1="630" y1="218" x2="375" y2="258" class="arrow"/>

  <!-- Runtime -->
  <rect x="175" y="262" width="400" height="48" class="box" fill="#1a1a2e" stroke="#e94560" stroke-width="2"/>
  <text x="375" y="283" text-anchor="middle" fill="#fff" font-size="14" font-weight="bold">💾 .missions/ — Runtime State Machine</text>
  <text x="375" y="300" text-anchor="middle" fill="#aaa" font-size="11">Created by agent at runtime</text>

  <line x1="225" y1="310" x2="100" y2="345" class="arrow"/>
  <line x1="375" y1="310" x2="375" y2="345" class="arrow"/>
  <line x1="525" y1="310" x2="650" y2="345" class="arrow"/>

  <!-- Bottom row -->
  <rect x="10" y="348" width="180" height="30" class="box" fill="#27ae60"/>
  <text x="100" y="368" text-anchor="middle" fill="#fff" font-size="12" font-weight="bold">config.yaml</text>

  <rect x="285" y="348" width="180" height="30" class="box" fill="#3498db"/>
  <text x="375" y="368" text-anchor="middle" fill="#fff" font-size="12" font-weight="bold">CONTRACT.md</text>

  <rect x="560" y="348" width="180" height="30" class="box" fill="#9b59b6"/>
  <text x="650" y="368" text-anchor="middle" fill="#fff" font-size="12" font-weight="bold">State folders (02→08)</text>
</svg>
</div>

---

## State Machine

<div align="center">
<svg width="750" height="400" viewBox="0 0 750 400" xmlns="http://www.w3.org/2000/svg">
  <style>
    text { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif; }
    .box { rx: 6; ry: 6; }
  </style>

  <!-- Center hub -->
  <circle cx="375" cy="200" r="42" fill="#1a1a2e" stroke="#e94560" stroke-width="2.5"/>
  <text x="375" y="194" text-anchor="middle" fill="#fff" font-size="11" font-weight="bold">File System</text>
  <text x="375" y="210" text-anchor="middle" fill="#e94560" font-size="10">State Machine</text>

  <!-- Left column -->
  <rect x="40" y="20" width="150" height="40" class="box" fill="#16213e"/>
  <text x="115" y="45" text-anchor="middle" fill="#fff" font-size="12" font-weight="bold">00-orchestrate</text>
  <line x1="190" y1="40" x2="335" y2="167" stroke="#666" stroke-width="1.5" stroke-dasharray="4,3"/>

  <rect x="40" y="85" width="150" height="40" class="box" fill="#0f3460"/>
  <text x="115" y="110" text-anchor="middle" fill="#fff" font-size="12" font-weight="bold">01-contract</text>
  <line x1="190" y1="105" x2="335" y2="180" stroke="#666" stroke-width="1.5" stroke-dasharray="4,3"/>

  <rect x="40" y="150" width="150" height="40" class="box" fill="#27ae60"/>
  <text x="115" y="175" text-anchor="middle" fill="#fff" font-size="12" font-weight="bold">02-ready ⏳</text>
  <line x1="190" y1="170" x2="335" y2="195" stroke="#27ae60" stroke-width="2"/>

  <rect x="40" y="215" width="150" height="40" class="box" fill="#f39c12"/>
  <text x="115" y="240" text-anchor="middle" fill="#fff" font-size="12" font-weight="bold">03-running ▶️</text>
  <line x1="190" y1="235" x2="335" y2="205" stroke="#f39c12" stroke-width="2"/>

  <rect x="40" y="280" width="150" height="40" class="box" fill="#3498db"/>
  <text x="115" y="305" text-anchor="middle" fill="#fff" font-size="12" font-weight="bold">04-review 👁️</text>
  <line x1="190" y1="300" x2="335" y2="215" stroke="#3498db" stroke-width="2"/>

  <!-- Right column -->
  <rect x="560" y="85" width="150" height="40" class="box" fill="#27ae60"/>
  <text x="635" y="110" text-anchor="middle" fill="#fff" font-size="12" font-weight="bold">05-done ✅</text>
  <line x1="560" y1="105" x2="415" y2="180" stroke="#27ae60" stroke-width="2"/>

  <rect x="560" y="150" width="150" height="40" class="box" fill="#e74c3c"/>
  <text x="635" y="175" text-anchor="middle" fill="#fff" font-size="12" font-weight="bold">06-fix 🐛</text>
  <line x1="560" y1="170" x2="415" y2="195" stroke="#e74c3c" stroke-width="2"/>

  <rect x="560" y="215" width="150" height="40" class="box" fill="#9b59b6"/>
  <text x="635" y="240" text-anchor="middle" fill="#fff" font-size="12" font-weight="bold">07-pr 📤</text>
  <line x1="560" y1="235" x2="415" y2="205" stroke="#9b59b6" stroke-width="2"/>

  <rect x="560" y="280" width="150" height="40" class="box" fill="#1a1a2e"/>
  <text x="635" y="305" text-anchor="middle" fill="#fff" font-size="12" font-weight="bold">08-merged 🎉</text>
  <line x1="560" y1="300" x2="415" y2="215" stroke="#666" stroke-width="1.5" stroke-dasharray="4,3"/>

  <rect x="560" y="340" width="150" height="36" class="box" fill="#7f8c8d"/>
  <text x="635" y="363" text-anchor="middle" fill="#fff" font-size="12" font-weight="bold">archive 📦</text>
  <line x1="560" y1="358" x2="415" y2="225" stroke="#7f8c8d" stroke-width="1.5" stroke-dasharray="4,3"/>

  <!-- Labels -->
  <text x="275" y="178" fill="#27ae60" font-size="11" font-weight="bold">mv</text>
  <text x="275" y="210" fill="#f39c12" font-size="11" font-weight="bold">mv</text>
  <text x="275" y="248" fill="#3498db" font-size="11" font-weight="bold">mv</text>
  <text x="495" y="178" fill="#27ae60" font-size="11" font-weight="bold">pass</text>
  <text x="495" y="210" fill="#e74c3c" font-size="11" font-weight="bold">fail</text>
  <text x="495" y="248" fill="#9b59b6" font-size="11" font-weight="bold">PR</text>
</svg>
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
│   ├── AGENTS.md                  ← Role protocols
│   ├── CONFIG.md                  ← Configuration guide
│   ├── PRINCIPLE.md               ← Design philosophy
│   └── WORKFLOW.md                ← State machine reference
└── assets/
    ├── feature-template.md        ← Task card template
    ├── fix-template.md            ← Fix card template
    ├── pr-template.md             ← PR description template
    └── validation-template.md     ← Validation report template
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

| Dimension | Original Missions | Missions Skill (v1.0) |
|-----------|------------------|-----------------------|
| Spec | None | ✅ **agentskills.io** compliant |
| Config | None | ✅ **config.yaml** driven |
| Templates | Hardcoded | ✅ **Overridable** assets/ |
| Roles | 3 fixed | ✅ **4 + extensible** |
| Hooks | None | ✅ **scripts/** lifecycle |
| Cross-platform | Claude Code only | ✅ **Multi-platform** |
| Progressive disclosure | None | ✅ **3-level loading** |

---

## License

[MIT](LICENSE)

## Changelog

- **v1.0.0** (2026-06-28): Initial release. Four roles, file-system state machine, PR workflow, agentskills.io compliant.
