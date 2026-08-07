---
name: code-review
description: Reviewing existing code changes for correctness, breaking changes, quality, plan conformance, consistency, and test coverage. Use when asked to review a change, a diff, or a set of modified files — even phrased as "look this over", "is this right", or right after implementing something that should be checked before it lands.
---

# Code review

Read the changed files in full context — the surrounding code, not just the diff — then judge the change across the dimensions below. Report findings by severity and conclude with a verdict.

## Dimensions

### Correctness
- Logic errors, off-by-one, null/undefined handling.
- Edge cases not covered (empty input, max values, concurrent access).
- Incorrect assumptions about external systems or APIs.

### Breaking changes
- Changes to public interfaces, exported functions, or data contracts.
- Renamed or removed symbols that may break callers.
- Behavioral changes in existing functionality.

### Code quality
- Naming clarity.
- Duplication that should be extracted — including a new path that duplicates one already present in a **touched file**, not only duplication within the diff.
- Unnecessary complexity, over-engineering, dead code.

### Plan conformance
- Does the implementation match the intent of the approved plan, when one is supplied?
- Steps skipped or implemented differently without a clear reason; changes present that were not in the plan.

### Consistency
- Adherence to existing patterns and conventions; formatting alignment.

### Test coverage
- New code paths tested; the plan's edge cases covered.

## Output

One finding per line:

```
[CRITICAL|WARNING|SUGGESTION] file/path.ext:line — description
```

- **CRITICAL** — must fix before merge (bugs, security issues, broken contracts).
- **WARNING** — should fix; not immediately breaking.
- **SUGGESTION** — optional improvement.

Conclude with `APPROVED` (no CRITICALs) or `CHANGES REQUESTED` (list the CRITICALs again).

Flag only what matters — if the codebase is already inconsistent, do not nitpick style. Be direct; do not soften CRITICALs.
