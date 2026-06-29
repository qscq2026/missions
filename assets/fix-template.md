---
id: {{feature_id}}-fix-{{fix_number}}
type: fix
agent: worker
milestone: {{milestone_id}}
root_feature: {{feature_id}}          # always the original F-xxx, never a prior fix card
parent: {{immediate_parent_id}}       # F-xxx for fix-001; F-xxx-fix-NNN for subsequent rounds
fix_number: {{fix_number}}            # sequential integer; increment per re-validation failure
contract_assertions: {{contract_assertions}}
---

# {{feature_id}}-fix-{{fix_number}}: Fix blocking issues in {{parent_title}}

## Context
- **Root feature**: {{feature_id}} (always the original task, for audit chain integrity)
- **Immediate parent**: {{immediate_parent_id}} (the card this fix is responding to)
- **Source**: Validator blocking issues — read `archive/{{immediate_parent_id}}.md` Validation Report

## Fixes Required
{{#each blocking_issues}}
{{@index}}. {{description}}
   - Assertion: {{assertion_id}}
   - Severity: {{severity}}
{{/each}}

## Verification
- [ ] All blocking issues resolved
- [ ] Original tests still pass
- [ ] New tests cover fix scenarios
- [ ] Lint clean

## Handoff
- [ ] Fix complete
- [ ] Tests pass
- [ ] Ready for re-validation
