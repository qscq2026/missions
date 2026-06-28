---
id: {{feature_id}}-fix-{{fix_number}}
type: fix
agent: worker
milestone: {{milestone_id}}
parent: {{feature_id}}
contract_assertions: {{contract_assertions}}
---

# {{feature_id}}-fix-{{fix_number}}: Fix blocking issues in {{parent_title}}

## Context
- **Parent**: {{feature_id}}
- **Source**: Validator blocking issues in {{feature_id}} Validation Report
- **Read**: `archive/{{feature_id}}.md` Validation Report

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
