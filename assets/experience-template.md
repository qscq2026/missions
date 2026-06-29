---
id: EXP-{{date}}-{{number}}
type: {{type}}  # pattern | anti-pattern | fix-strategy
category: {{category}}  # tdd | validation | architecture | performance
severity: {{severity}}  # critical | major | minor | tip
task_id: {{task_id}}
mission_id: {{mission_id}}
created: {{created_at}}
last_applied: {{last_applied}}
aply_count: {{apply_count}}
---

# {{title}}

## Context
{{context}}

## What Happened
{{description}}

## Root Cause
{{root_cause}}

## Solution / Pattern
{{solution}}

## Code Example
```{{language}}
{{code_example}}
```

## Prevention
{{prevention}}

## Related
{{#each related_experiences}}
- [{{id}}]({{id}}.md): {{title}}
{{/each}}

## Verification
- [ ] Applied in subsequent missions
- [ ] Confirmed effective
- [ ] Documented in team wiki

---

> **Experience Library**: This record is used for self-improvement.
> Agents should read relevant experiences before starting similar tasks.
