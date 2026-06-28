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
2. **Clarify**: Ask the user up to 3 focused questions about technical choices (e.g., database, framework, auth method). Do not ask "what do you want" — ask "PostgreSQL or SQLite?"
3. **Lock CONTRACT**: Write `.missions/CONTRACT.md` with:
   - Global constraints (e.g., "All APIs return JSON", "Coverage ≥ 80%")
   - Behavioral assertions (ID, Behavior, Tool, Evidence)
   - Coverage map (which assertions cover which features)
   - Status: `locked`, timestamp, version
4. **Create milestones**: Write milestone definitions to `.missions/00-orchestrate/`.
5. **Create task cards**: For each feature, write a card to `.missions/02-ready/` using the template from `assets/feature-template.md`.
6. **Update dashboard**: Write `.missions/README.md` with initial status.
7. **Stop**: Do not implement. Hand off to Worker.

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
2. **Fresh start**: Forget all previous conversation. Read only:
   - This role protocol
   - The task card in `03-running/`
   - `CONTRACT.md` assertions linked to this feature
   - `config.yaml` for project constraints
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
2. **Read evidence**: Load the task card from `04-review/`. Read ONLY:
   - The `## Handoff` section (commands run, test output, commit hash)
   - Git diff of the commit
3. **Do NOT read**: Worker reasoning, implementation details, or conversation history
4. **Run verification**:
   - Execute test suite
   - Run linters
   - Run type checkers
   - If configured, run E2E tests (playwright, etc.)
5. **Fill Validation Report**: In the task card, complete `## Validation Report`:
   - Test results (pass/fail)
   - Lint results
   - Issues table: severity (blocking/non-blocking/suggestion), description, related assertion
   - Verdict: `pass` or `fail`
6. **Route**:
   - If **zero blocking**: `mv .missions/04-review/XXX.md .missions/05-done/XXX.md`
   - If **blocking issues**: Create `.missions/06-fix/XXX-fix-001.md` using `assets/fix-template.md`, then `mv .missions/04-review/XXX.md .missions/archive/XXX.md`
7. **Update dashboard**: Append status to `.missions/README.md`

### Constraints

- Do NOT read implementation code details (only test results and git diff)
- Do NOT modify source code
- Do NOT read Worker reasoning or conversation history
- Must be objective — no "it looks fine" without evidence

---

## Role: PR Author

**When to activate**: When all features of a milestone are in `05-done/`.

**Goal**: Summarize all evidence into a human-readable PR description.

### Workflow

1. **Collect**: Gather all `05-done/*.md` files for the completed milestone.
2. **Read**: Load their Handoffs and Validation Reports.
3. **Git summary**: Run `git log --oneline {milestone-start}..HEAD` and `git diff --stat`.
4. **Coverage**: Run `pytest --cov` to get coverage metrics.
5. **Generate PR**: Write `.missions/07-pr/PR-{milestone}.md` using `assets/pr-template.md`:
   - Summary
   - Changes (file list)
   - Test coverage
   - Validation report summary
   - Contract coverage matrix
   - Review notes (human attention points)
   - Merge checklist
6. **Update dashboard**: Set status to "awaiting human review"
7. **Stop**: Wait for human to create PR on GitHub and merge.

### Constraints

- Do NOT modify source code
- Do NOT modify `CONTRACT.md`
- Do NOT call GitHub/GitLab APIs directly
- Generate Markdown only — human handles the actual PR

---

## Role Extension (Optional)

To add a custom role, append a section here and add trigger conditions to `config.yaml`:

```markdown
## Role: Security Auditor
**When to activate**: When feature involves auth, crypto, or payment.
**Goal**: Review security posture.
**Workflow**: ...
```
