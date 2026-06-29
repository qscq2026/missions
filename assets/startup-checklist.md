# Reactivation Checklist

> Agent MUST complete this checklist before executing any role.
> This ensures experience is always loaded and applied.

## Start Type Detection

- [ ] **Detected start type**: [cold / resume / new / recovery]
  - Cold: `.missions/` does not exist
  - Resume: `03-running/` has files
  - New: last mission completed, user has new goal
  - Recovery: task stuck or agent crashed

## Files Loaded

- [ ] `SKILL.md` — skill entry point
- [ ] `config.yaml` — user configuration
- [ ] `AGENTS.md` — role protocols
- [ ] **`.missions/logs/experience/INDEX.md` — experience library**
- [ ] **Relevant experiences (top 5 by severity)**

## Experience Status

- [ ] Total experiences in library: {{total_experiences}}
- [ ] Experiences matching current task: {{matching_experiences}}
- [ ] Critical anti-patterns loaded: {{critical_warnings}}
- [ ] Proven patterns available: {{available_patterns}}

## Current State

- [ ] `mission_status`: {{mission_status}}
- [ ] `current_agent`: {{current_agent}}
- [ ] `current_task`: {{current_task}}
- [ ] Active state folder: {{active_folder}}

## Ready to Execute

- [ ] Role identified: [Orchestrator / Worker / Validator / PR Author / Logger / Experience Curator]
- [ ] Experience loaded and understood
- [ ] No blocking anti-patterns for current task
- [ ] Ready to proceed with execution

---

**If experience INDEX is missing or empty:**
1. Check if `.missions/logs/experience/` exists
2. If not, copy seed experiences from skill: `cp {skillDir}/references/examples/experience/* .missions/logs/experience/`
3. Regenerate INDEX
4. Report: "Experience library initialized with seed data"
