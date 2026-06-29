---
id: EXP-SEED-001
type: pattern
category: tdd
severity: major
task_id: F-001
mission_id: M1
created: 2026-06-28T10:00:00Z
last_applied: 2026-06-28T15:00:00Z
apply_count: 3
---

# Pattern: Mock External Dependencies in Unit Tests

## Context
When implementing features that interact with databases, APIs, or external services.

## What Happened
Initial tests for F-001 (user auth) used real PostgreSQL connection. Tests were slow (~2s each) and flaky in CI.

## Root Cause
Unit tests should not depend on external state. Integration tests are separate.

## Solution
Always mock external dependencies in unit tests:

```python
# ❌ Bad: Real DB
from sqlalchemy import create_engine
engine = create_engine(os.getenv("DATABASE_URL"))

# ✅ Good: Mocked DB
from unittest.mock import MagicMock, patch

@patch("src.db.get_session")
def test_create_user(mock_session):
    mock_session.return_value = MagicMock()
    # ... test logic
```

## Prevention
- Add `mock` and `pytest-mock` to dev dependencies
- Create `conftest.py` with shared fixtures
- Document: "Unit tests = mocked, Integration tests = real"

## Related
- [EXP-SEED-002](EXP-SEED-002.md): Integration test setup pattern
