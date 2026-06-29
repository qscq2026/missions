# Mission Metrics: {{mission_id}}

## Overview
- **Mission**: {{mission_name}}
- **Duration**: {{duration}}
- **Status**: {{status}}

## Agent Activity

| Role | Runs | Avg Time | Success Rate | Tokens Used |
|------|------|----------|--------------|-------------|
{{#each role_metrics}}
| {{role}} | {{runs}} | {{avg_time}} | {{success_rate}}% | {{tokens}} |
{{/each}}

## Efficiency

| Metric | Value | Target | Status |
|--------|-------|--------|--------|
| Features / Milestone | {{features_per_milestone}} | 5-10 | {{features_status}} |
| Fix Rate | {{fix_rate}}% | <20% | {{fix_status}} |
| Avg Validation Time | {{avg_validation_time}} | <5min | {{validation_status}} |
| Token Efficiency | {{token_efficiency}} | >80% | {{token_status}} |
| Cache Hit Rate | {{cache_hit_rate}}% | >90% | {{cache_status}} |

## Issue Distribution

| Type | Count | % | Trend |
|------|-------|---|-------|
{{#each issue_distribution}}
| {{type}} | {{count}} | {{percentage}}% | {{trend}} |
{{/each}}

## Comparison with Previous

| Metric | This Mission | Previous | Change |
|--------|-------------|----------|--------|
| Total Time | {{this_time}} | {{prev_time}} | {{time_change}} |
| Total Tokens | {{this_tokens}} | {{prev_tokens}} | {{token_change}} |
| Blocking Issues | {{this_blocking}} | {{prev_blocking}} | {{blocking_change}} |
| Coverage | {{this_coverage}}% | {{prev_coverage}}% | {{coverage_change}} |

## Recommendations

{{#each recommendations}}
- **{{priority}}**: {{description}}
{{/each}}
