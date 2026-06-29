# Experience Index

> Auto-generated index of all lessons learned across missions.
> Updated after each mission completion.

## By Category

### TDD & Testing
{{#each tdd_experiences}}
- [{{id}}]({{path}}): {{title}} ({{severity}})
{{/each}}

### Validation & Quality
{{#each validation_experiences}}
- [{{id}}]({{path}}): {{title}} ({{severity}})
{{/each}}

### Architecture
{{#each architecture_experiences}}
- [{{id}}]({{path}}): {{title}} ({{severity}})
{{/each}}

### Performance
{{#each performance_experiences}}
- [{{id}}]({{path}}): {{title}} ({{severity}})
{{/each}}

## By Severity

### Critical (Must Avoid)
{{#each critical_experiences}}
- [{{id}}]({{path}}): {{title}} ({{category}})
{{/each}}

### Major (Watch Out)
{{#each major_experiences}}
- [{{id}}]({{path}}): {{title}} ({{category}})
{{/each}}

### Minor (Good to Know)
{{#each minor_experiences}}
- [{{id}}]({{path}}): {{title}} ({{category}})
{{/each}}

## Most Applied

{{#each most_applied}}
- [{{id}}]({{path}}): {{title}} (applied {{apply_count}} times)
{{/each}}

## Recently Added

{{#each recent_experiences}}
- [{{id}}]({{path}}): {{title}} ({{created_at}})
{{/each}}
