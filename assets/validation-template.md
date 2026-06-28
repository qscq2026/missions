## Validation Report

**Validator**: {{validator_name}}
**Date**: {{date}}
**Feature**: {{feature_id}}
**Strict Mode**: {{#if roles.validator.strict_mode}}ON{{else}}OFF{{/if}}

### Test Execution
```bash
{{test_command}}
```
**Result**: {{test_result}}

### Lint
```bash
{{lint_command}}
```
**Result**: {{lint_result}}

{{#if roles.validator.run_e2e}}
### E2E ({{roles.validator.e2e_tool}})
```bash
{{e2e_command}}
```
**Result**: {{e2e_result}}
{{/if}}

### Issues

| # | Severity | Assertion | Description |
|---|----------|-----------|-------------|
{{#each issues}}
| {{@index}} | {{severity}} | {{assertion_id}} | {{description}} |
{{/each}}

### Verdict
{{#if has_blocking}}
❌ **FAIL** — {{blocking_count}} blocking issues must be fixed
{{else}}
✅ **PASS** — Ready for `05-done/`
{{#if has_non_blocking}}
⚠️ {{non_blocking_count}} non-blocking issues noted
{{/if}}
{{/if}}
