# Missions Configuration Guide

Create `.missions/config.yaml` in your project to customize behavior.

## Minimal Config

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

## Full Reference

### project

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| name | string | "" | Project name |
| language | string | "python" | python, typescript, go, rust, java |
| framework | string | "" | fastapi, django, express, spring, etc. |
| package_manager | string | "" | poetry, npm, cargo, etc. |

### roles.orchestrator

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| max_clarification_questions | int | 3 | Max questions to ask user |
| contract_lock_on_start | bool | true | Lock contract before any code |
| allow_scope_change_mid_mission | bool | false | Allow changing requirements mid-flight |

### roles.worker

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| enforce_tdd | bool | true | Require tests before implementation |
| min_coverage | int | 80 | Minimum test coverage % |
| max_lines_per_feature | int | 200 | Max lines changed per feature |
| allowed_linters | list | [ruff, mypy] | Linters to run |
| forbidden_patterns | list | [] | Code patterns to reject |

### roles.validator

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| strict_mode | bool | true | true = blocking must fix, false = warn only |
| run_e2e | bool | true | Run end-to-end tests |
| e2e_tool | string | "playwright" | playwright, selenium, cypress |

### roles.pr_author

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| include_coverage_badge | bool | true | Show coverage in PR |
| include_contract_matrix | bool | true | Show assertion coverage |
| auto_generate_changelog | bool | false | Auto-update CHANGELOG |

### workflow

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| serial_write | bool | true | Enforce serial file writes |
| parallel_read | bool | true | Allow parallel reads |
| auto_create_fix | bool | true | Auto-create fix cards on blocking |
| auto_generate_pr | bool | true | Auto-generate PR on milestone done |

### milestones

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| naming_pattern | string | "M{number}: {name}" | Milestone naming |
| require_all_done_before_pr | bool | true | Wait for all features before PR |
| max_features_per_milestone | int | 10 | Max features per milestone |

## Customization Levels

1. **Level 1** (Easy): Edit `config.yaml`
2. **Level 2** (Medium): Override templates in `assets/`
3. **Level 3** (Advanced): Add roles in `references/AGENTS.md`
4. **Level 4** (Expert): Add hooks in `scripts/`
