---
id: {{feature_id}}
type: {{type}}
agent: worker
milestone: {{milestone_id}}
contract_assertions: {{contract_assertions}}
parent: {{parent_id}}
created: {{created_at}}
---

# {{feature_id}}: {{title}}

## Context
- **Prerequisites**: {{preconditions}}
- **Read**: `AGENTS.md` Worker section + `CONTRACT.md` assertions {{contract_assertions}}
- **Project**: {{project.language}} + {{project.framework}}

## Requirements
{{#if roles.worker.enforce_tdd}}
1. **Write tests first** covering assertions:
   {{#each contract_assertions}}
   - {{.}}
   {{/each}}
2. **Implement** to make tests pass
{{else}}
1. **Implement** the feature
{{/if}}
3. **Lint** with {{#each roles.worker.allowed_linters}}{{.}}{{#unless @last}}, {{/unless}}{{/each}}
4. **Coverage** ≥ {{roles.worker.min_coverage}}%
5. **Max lines** ≤ {{roles.worker.max_lines_per_feature}}

## Handoff (Worker completes)
- [ ] Tests written (if TDD enforced)
- [ ] All tests pass
- [ ] Lint clean
- [ ] Coverage ≥ {{roles.worker.min_coverage}}%
- [ ] Git committed
- [ ] Handoff filled

### Git Commit
```
Hash:
Message:
```

### Issues & Compromises
<!-- Traps, technical debt, known limitations -->

---

## Validation Report (Validator only)

### Results
- [ ] Tests pass
- [ ] Lint clean
- [ ] Assertions covered

### Issues
| Severity | Count | Description | Assertion |
|----------|-------|-------------|-----------|
| blocking | 0 | | |
| non-blocking | 0 | | |
| suggestion | 0 | | |

### Verdict
<!-- pass / fail -->

---

## History
- `{{created_at}}` — Created by Orchestrator in `02-ready/`
