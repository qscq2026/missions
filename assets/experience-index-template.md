# Experience Index

> Maintained by Experience Curator. Updated after each milestone completion or blocking fix resolution.
> Format is fixed — do not alter section headers or list syntax; agent relevance matching depends on this structure.
>
> **Maintenance rules**:
> - Add new entries under the correct category and severity section.
> - Each entry format: `- [EXP-ID](relative/path/EXP-ID.md): Title (severity)`
> - Update "Most Applied" only when `apply_count` reaches a new high.
> - "Recently Added" shows the 5 most recently created records.

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
