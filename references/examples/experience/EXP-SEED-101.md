---
id: EXP-SEED-101
type: anti-pattern
category: validation
severity: critical
task_id: F-002
mission_id: M1
created: 2026-06-28T11:00:00Z
last_applied: null
apply_count: 0
---

# Anti-Pattern: Self-Evaluating Tests

## Context
When Worker writes tests and then immediately runs them to "verify" their own implementation.

## What Happened
F-002 (channel creation) had tests that passed but didn't actually assert the right behavior. The test checked `response.status_code == 200` but didn't verify the channel was actually created in the database.

## Root Cause
Worker bias: "I wrote this code, so it must be correct." The test was written to confirm the implementation, not to independently verify it.

## Root Cause (Deeper)
This is the Self-Evaluation Bias documented in Factory's Missions research. The same agent that implements cannot objectively evaluate.

## Solution
1. **Validator must be a separate role** with fresh context
2. **Tests must be written before implementation** (TDD)
3. **Validator reads only CONTRACT.md assertions**, not implementation
4. **Validator runs tests without seeing Worker reasoning**

## Prevention
- config.yaml: `roles.worker.enforce_tdd: true`
- config.yaml: `roles.validator.strict_mode: true`
- AGENTS.md: Validator "禁止看实现代码细节"

## Impact
Without this separation, F-002 would have shipped with a bug where channels appeared created (200 OK) but weren't persisted.

## Related
- [EXP-SEED-001](EXP-SEED-001.md): Mock pattern
- Factory Missions research: Context Dilution & Self-Evaluation Bias
