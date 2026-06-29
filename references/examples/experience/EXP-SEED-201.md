---
id: EXP-SEED-201
type: fix-strategy
category: architecture
severity: major
task_id: F-001-fix-001
mission_id: M1
created: 2026-06-28T14:00:00Z
last_applied: 2026-06-28T16:00:00Z
apply_count: 2
---

# Fix Strategy: Adding Missing JWT Refresh Token

## Context
Login endpoint returned `access_token` but not `refresh_token` as required by VAL-002.

## What Happened
Validator caught missing `refresh_token` in response. Marked as blocking.

## Root Cause
Worker focused on access token (primary requirement) and overlooked refresh token (secondary but required by contract).

## Solution

```python
# Before (missing refresh_token)
@app.post("/api/auth/login")
def login(credentials: LoginRequest):
    user = authenticate(credentials)
    access_token = create_access_token(user.id)
    return {"access_token": access_token}  # ❌ Missing refresh_token

# After (with refresh_token)
@app.post("/api/auth/login")
def login(credentials: LoginRequest):
    user = authenticate(credentials)
    access_token = create_access_token(user.id)
    refresh_token = create_refresh_token(user.id)
    return {
        "access_token": access_token,
        "refresh_token": refresh_token,  # ✅ Added
        "token_type": "bearer"
    }
```

## Prevention
- Add "response schema validation" to test suite
- Use Pydantic response models that enforce field presence
- Validator checks: `assert "refresh_token" in response.json()`

## Reusability
This pattern applies to any auth-related feature:
- OAuth callback handlers
- Token refresh endpoints
- Password reset flows

## Related
- [EXP-SEED-001](EXP-SEED-001.md): Mock pattern for auth tests
