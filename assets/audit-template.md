# Audit Log: {{date}}

## Mission: {{mission_id}}
**Started**: {{start_time}}  
**Completed**: {{end_time}}  
**Duration**: {{duration}}  
**Status**: {{status}}

## Agent Execution Log

| # | Role | Task | Start | End | Tokens | Status | Notes |
|---|------|------|-------|-----|--------|--------|-------|
{{#each executions}}
| {{@index}} | {{role}} | {{task_id}} | {{start}} | {{end}} | {{tokens}} | {{status}} | {{notes}} |
{{/each}}

## Token Usage Summary

| Role | Input | Output | Cached | Total |
|------|-------|--------|--------|-------|
{{#each token_summary}}
| {{role}} | {{input}} | {{output}} | {{cached}} | {{total}} |
{{/each}}

## State Transitions

```
{{#each transitions}}
{{from}} --[{{action}}]--> {{to}}  ({{task_id}})
{{/each}}
```

## Issues Encountered

{{#each issues}}
### {{type}}: {{title}}
- **Severity**: {{severity}}
- **Task**: {{task_id}}
- **Description**: {{description}}
- **Resolution**: {{resolution}}
- **Time to Fix**: {{fix_duration}}
{{/each}}

## Files Modified

```bash
{{git_log}}
```

## Coverage Evolution

| Milestone | Start | End | Delta |
|-----------|-------|-----|-------|
{{#each coverage_evolution}}
| {{milestone}} | {{start}}% | {{end}}% | +{{delta}}% |
{{/each}}

## Human Interventions

{{#each human_interventions}}
- **Time**: {{time}}
- **Reason**: {{reason}}
- **Action**: {{action}}
{{/each}}

---

> This log is auto-generated. Do not modify manually.
