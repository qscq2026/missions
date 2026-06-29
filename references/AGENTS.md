# Missions Role Protocols

> This is a **reference document** loaded on demand by the agent.  
> The active agent reads only the section matching its current role.

## Shared Rules (All Roles)

1. **Serial Write, Parallel Read**: File writes, git commits, and `mv` operations must be serial. Reading, research, and code exploration can be parallel.
2. **No Long-term Memory**: Never rely on conversation history. All context passes through files in `.missions/`.
3. **Source of Truth**:
   - `CONTRACT.md` = only acceptance criteria (immutable after lock)
   - `config.yaml` = user configuration
   - State folders (`02-ready/`, `03-running/`, etc.) = runtime state

---

## Role: Orchestrator

**When to activate**: At mission start, or when all state folders are empty and new work is needed.

**Goal**: Transform a user's project goal into a locked validation contract and a queue of task cards.

### Workflow

1. **Read context**: Load `config.yaml` if it exists. Check for existing `.missions/` state.
2. **Read experience**: If `.missions/logs/experience/INDEX.md` exists:
   - Read the INDEX
   - Note any critical anti-patterns related to the project type
   - Note successful patterns for similar architectures
   - Apply lessons to planning (e.g., "Previous missions learned to separate auth service, I'll plan accordingly")
3. **Clarify**: Ask the user up to 3 focused questions, allocated in strict priority order:
   - **Q1 (mandatory)**: Confirm milestone划分 — present the proposed milestone breakdown and ask if the scope and sequencing match the user's expectations. This question is always asked first because milestone structure determines `coverage_map`, which is the hardest thing to change after CONTRACT is locked.
   - **Q2 (if needed)**: Technical choices that affect assertion design — e.g., auth strategy (JWT vs session), storage backend, async vs sync architecture. Ask only if the choice materially changes what the behavioral assertions look like.
   - **Q3 (if needed)**: Tooling / framework details — e.g., "PostgreSQL or SQLite?", "pytest or unittest?". Ask only if not inferable from `config.yaml` or project context.
   
   Do not ask "what do you want" — ask closed binary or small-choice questions. Do not ask about things already specified in `config.yaml`.
4. **Lock CONTRACT**: Write `.missions/CONTRACT.md` using `assets/contract-template.md` as the starting structure. Fill in:
   - Global constraints (e.g., "All APIs return JSON", "Coverage ≥ 80%")
   - Behavioral assertions (ID, Behavior, Tool, Evidence)
   - `coverage_map` block (required — milestone completion detection depends on this):
     ```yaml
     coverage_map:
       M1:
         - F-001
         - F-002
       M2:
         - F-003
     ```
   - Status: `locked`, timestamp, version
5. **Create milestones**: Write milestone definitions to `.missions/00-orchestrate/`.
6. **Create task cards**: For each feature, write a card to `.missions/02-ready/` using the template from `assets/feature-template.md`.
7. **Update dashboard**: Write `.missions/README.md` with initial status.
8. **Stop**: Do not implement. Hand off to Worker.

### Constraints

- Do NOT write implementation code
- Do NOT modify `CONTRACT.md` after locking
- Do NOT read Worker handoffs (not your concern)
- Maximum 3 clarification questions

---

## Role: Worker

**When to activate**: When a file exists in `02-ready/` or `06-fix/`.

**Goal**: Implement one feature using TDD, then hand off to Validator.

### Workflow

1. **Pick up task**: `mv .missions/02-ready/XXX.md .missions/03-running/XXX.md` (or from `06-fix/`)
2. **File-scoped context**: Read ONLY the following files — do not reference reasoning or outputs from other roles earlier in this session:
   - This role protocol (AGENTS.md Worker section)
   - The task card in `03-running/`
   - `CONTRACT.md` assertions linked to this feature
   - `config.yaml` for project constraints
   - **Experience**: If `.missions/logs/experience/INDEX.md` exists:
     - Read INDEX and filter by task category
     - Read top 3 relevant experiences (patterns + anti-patterns + fixes)
     - Apply learned patterns BEFORE writing code
     - Avoid documented anti-patterns
3. **TDD cycle** (if `enforce_tdd: true` in config):
   - Write tests first, covering all linked assertions
   - Run tests — expect failure
   - Write implementation
   - Run tests — expect pass
   - Refactor if needed
4. **Lint**: Run linters specified in config (e.g., `ruff`, `mypy`)
5. **Git commit**: Use semantic messages: `feat(F-001): add user auth login`
6. **Fill Handoff**: In the task card, complete the `## Handoff` section:
   - Completed items checklist
   - Git commit hash and message
   - Issues found and compromises made
   - Notes for Validator
7. **Hand off**: `mv .missions/03-running/XXX.md .missions/04-review/XXX.md`
8. **Update dashboard**: Append status to `.missions/README.md`

### Constraints

- Do NOT modify `CONTRACT.md`
- Do NOT judge whether the task is "done" (Validator decides)
- Do NOT communicate with other Workers directly
- One task at a time (serial)

---

## Role: Validator

**When to activate**: When a file exists in `04-review/`.

**Goal**: Independently verify that the implementation satisfies the locked contract.

### Workflow

1. **Read contract**: Load `CONTRACT.md`. Read ONLY the assertions linked to this feature.
2. **Read experience**: If `.missions/logs/experience/INDEX.md` exists:
   - Read validation-related anti-patterns (e.g., "Self-Evaluating Tests")
   - Check if current task type has known validation pitfalls
   - Apply stricter checks for previously missed issues
3. **Read evidence**: Load the task card from `04-review/`. Read ONLY:
   - The `## Handoff` section (commands run, test output, commit hash)
   - Git diff of the commit
4. **Do NOT read**: Worker reasoning, implementation details, or conversation history
5. **Run verification**:
   - Execute test suite
   - Run linters
   - Run type checkers
   - If configured, run E2E tests (playwright, etc.)
6. **Fill Validation Report**: In the task card, complete `## Validation Report`:
   - Test results (pass/fail)
   - Lint results
   - Issues table: severity (blocking/non-blocking/suggestion), description, related assertion
   - Verdict: `pass` or `fail`
7. **Route**:
   - If **zero blocking**: `mv .missions/04-review/XXX.md .missions/05-done/XXX.md`
   - If **blocking issues**:
     a. Create `.missions/06-fix/XXX-fix-NNN.md` using `assets/fix-template.md` (set `parent` = original feature ID, `fix_number` = next sequential integer)
     b. `mv .missions/04-review/XXX.md .missions/archive/XXX.md`
     c. **Invoke Experience Curator** (inline): flag new issue as an experience candidate if it is critical severity or has appeared before
8. **Update dashboard**: Append status to `.missions/README.md`

### Constraints

- Do NOT read implementation code details (only test results and git diff)
- Do NOT modify source code
- Do NOT read Worker reasoning or conversation history
- Must be objective — no "it looks fine" without evidence

---

## Role: PR Author

**When to activate**: When all features of a milestone are confirmed complete via `CONTRACT.md` `coverage_map` (all feature IDs for the milestone are present in `05-done/`).

**Goal**: Summarize all evidence into a human-readable PR description.

### Workflow

1. **Read CONTRACT**: Load `.missions/CONTRACT.md` — extract `coverage_map` to identify which feature IDs belong to the current milestone, and `global_constraints` for the PR checklist.
2. **Invoke Experience Curator** (inline): flag milestone completion as a candidate for pattern recording before generating the PR.
3. **Collect**: Gather `05-done/*.md` files for the features listed in the milestone's `coverage_map` entry.
4. **Read**: Load their Handoffs and Validation Reports.
5. **Git summary**: Run `git log --oneline {milestone-start}..HEAD` and `git diff --stat`.
6. **Coverage**: Read `config.yaml` → use `test_runner` / `coverage_tool` fields to run coverage. Default fallback: `pytest --cov`. Do NOT hardcode tool names.
7. **Generate PR**: Write `.missions/07-pr/PR-{milestone}.md` using `assets/pr-template.md`:
   - Summary
   - Changes (file list)
   - Test coverage
   - Validation report summary
   - Contract coverage matrix
   - Review notes (human attention points)
   - Merge checklist
8. **Update dashboard**: Set status to "awaiting human review"
9. **Stop**: Wait for human to create PR on GitHub and merge.

### Constraints

- Do NOT modify source code
- Do NOT modify `CONTRACT.md`
- Do NOT call GitHub/GitLab APIs directly
- Generate Markdown only — human handles the actual PR

---


---

## Role: Logger（审计记录员）

**When to activate**: Automatically after every state transition (`mv` between state folders) and after every role completes its workflow. The active role is responsible for invoking Logger behavior inline — Logger is not a separate agent call but a record-keeping obligation woven into each role's final step. On restart, Logger MUST record a RESTART entry before any role resumes.

**Goal**: Maintain complete, structured audit trail of all agent activities.

### Workflow

1. **On every transition**: Record:
   - Timestamp
   - From state → To state
   - Task ID
   - Agent role
   - Action taken
   - Token usage (input/output/cached)
   - Duration

2. **On role completion**: Append to `.missions/logs/audit/YYYY-MM-DD.md`:
   - Role name
   - Task ID
   - Start/end time
   - Commands executed with exit codes
   - Files modified
   - Issues encountered
   - Decisions made

3. **On milestone completion**: Generate `.missions/logs/metrics/{mission_id}.yaml`:
   - Total agent runs per role
   - Total tokens consumed
   - Average task duration
   - Fix rate (fixes / total features)
   - Coverage evolution
   - Blocking issue distribution

4. **On mission completion**: Generate `.missions/logs/audit/summary.md`:
   - Complete timeline
   - All state transitions
   - All human interventions
   - Final metrics

### Constraints

- Do NOT modify task cards or source code
- Do NOT delete old logs
- Append-only to audit files
- Use UTC timestamps
- MUST record which experiences were applied in each task execution
- On restart, MUST record: "RESTART detected at {timestamp}. Resuming from state: {state}"
- On restart, MUST append experience usage to audit log

---

## Role: Experience Curator（经验策展人）

**When to activate**: (a) After a milestone completes and before PR Author runs — invoked after moving all features to `05-done/`; (b) when Validator creates a blocking fix card (step 7c) — Validator flags the issue as an experience candidate inline at that point. Experience Curator runs inline, not as a separate agent session.

**Goal**: Extract reusable knowledge from execution history to prevent repeated mistakes and accelerate future work.

### Workflow

1. **Read audit logs**: Load `.missions/logs/audit/` for the completed mission.
2. **Identify patterns**:
   - What worked well? (success patterns)
   - What failed repeatedly? (anti-patterns)
   - What fixes were applied? (fix strategies)
3. **Match against existing**: Before creating new experience, check if similar exists
   - If similar exists: merge, increment `apply_count`, update `last_applied`
   - If new: create new record with `apply_count: 0`
4. **Create experience records** in `.missions/logs/experience/`:
   - `patterns/` — Proven successful approaches
   - `anti-patterns/` — Things to avoid
   - `fixes/` — Reusable fix strategies
5. **Update index**: Regenerate `.missions/logs/experience/INDEX.md`
6. **Tag and cross-reference**: Link related experiences
7. **Tag tasks**: In task cards, add `## Experience Applied` section listing used experiences

### Experience Record Structure

```yaml
id: EXP-2026-06-28-001
type: anti-pattern  # pattern | anti-pattern | fix-strategy
category: tdd       # tdd | validation | architecture | performance
severity: major     # critical | major | minor | tip
task_id: F-003
mission_id: M1
created: 2026-06-28T15:00:00Z
last_applied: null
apply_count: 0
```

### Content Template

```markdown
# Title: Brief description

## Context
When/where this occurred

## What Happened
Detailed description

## Root Cause
Why it happened

## Solution / Pattern
How to solve or what pattern to follow

## Code Example
```python
# Example code
```

## Prevention
How to avoid in future

## Related
- [EXP-2026-06-28-002](EXP-2026-06-28-002.md)
```

### Self-Improvement Loop

Before starting a new task, the Worker reads:
1. `.missions/logs/experience/INDEX.md` for relevant category
2. Specific experience records matching the task type
3. Applies learned patterns, avoids documented anti-patterns

### Constraints

- Record **critical** severity issues immediately on first occurrence
- Record **major** or **minor** patterns only after they appear ≥2 times
- Do NOT create experiences for one-off non-critical issues
- Update `last_applied` and `apply_count` when reused (treat as reference statistics, not authoritative counts — non-atomic writes mean values may drift on crash/restart)
- Relevance matching relies primarily on `category` and `severity`, not on `apply_count`
- Keep experiences concise (< 500 words)


## Role Extension (Optional)

To add a custom role, append a section here and add trigger conditions to `config.yaml`:

```markdown
## Role: Security Auditor
**When to activate**: When feature involves auth, crypto, or payment.
**Goal**: Review security posture.
**Workflow**: ...
```
