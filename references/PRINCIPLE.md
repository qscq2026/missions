# Missions Design Principles

## Core Insight

> **"The bottleneck is not intelligence, but human attention."**

Modern models can handle 50 parallel tasks. Humans can handle 3-4. Missions bridges this gap by making the agent self-organize like an engineering team.

## Why File System as State Machine?

| Approach | Pros | Cons |
|----------|------|------|
| Database | Fast queries | Requires setup, schema migration |
| In-memory | Fast access | Lost on restart, not auditable |
| **File system** | Zero setup, git-trackable, auditable, universal | Slower than DB |

**Verdict**: For agent workflows, auditability beats speed.

## Why Pre-locked Contracts?

Traditional flow: Code → Tests → "Tests confirm my code"
Problem: Tests shaped by implementation. Coverage is an illusion.

Missions flow: Lock Contract → Tests (covering contract) → Implementation (satisfying tests)
Result: Tests are truly independent verification.

## Why Role Separation?

| Single Agent | Multi-Role |
|-------------|-----------|
| Self-evaluation bias | Independent validation |
| Context dilution | Fresh start per role |
| "Looks fine to me" | Objective evidence required |

## Progressive Disclosure

This skill follows agentskills.io:

- **Level 1** (~100 tokens): Name + description at startup
- **Level 2** (~3000 tokens): SKILL.md body when activated
- **Level 3** (on demand): References, templates, scripts

This keeps the agent's baseline context lean while providing depth when needed.
