---
name: testing
description: Test-writing conventions and standards. Use whenever writing, modifying, or reviewing tests — unit tests, integration tests, test naming, mocking, or when adding coverage for changed code. Trigger even when the user only implies tests (e.g. "add coverage", "make sure this is tested", or after implementing a function that needs verification).
---

# Testing

Reference consulted when writing or changing tests. Unit tests verify logic in
isolation; integration tests verify that the pieces work together.

## Unit tests (the default)

- Write a unit test for every discrete piece of logic.
- Mock every external dependency — databases, APIs, filesystem, clocks — so the
  test never depends on infrastructure. A test that needs infrastructure to pass
  is testing the wrong thing.
- Assert one behavior per test, so a failure names exactly what broke.
- Name tests Given-When-Then, describing behavior rather than implementation, so
  the name alone tells you what regressed:
  - Good: `givenEmptyRepository_whenSearching_thenReturnsEmptyList`
  - Bad: `test_query_method`
- Keep logic out of setup. Extract complex setup into named factory or builder
  helpers, so the setup reads as intent rather than machinery.

## Integration tests (targeted, not exhaustive)

- Write a small number that exercise the end-to-end path of the change — enough
  to confirm the wired-together system behaves.
- Cover the seams, not the logic — leave to unit tests what they already prove.

## Expanding existing tests

Read the actual test file before changing anything. Its structure decides where
coverage belongs: a parameterized test wants a new row in its data provider, not
a parallel test case beside it. Suggesting a new case when the correct move is a
new data-provider entry means you skipped this read.

- Extend the existing test when a change extends existing behavior, keeping one
  test per behavior rather than a parallel case beside it.
- Audit a function's current tests before modifying it, and close the coverage
  gaps in the same commit — every modified path accounted for.
- Keep every passing test honest: after a refactor, a test that no longer
  reflects real behavior is updated to match it, not left green.
- Test cheaply with real code rather than mocking it where the real thing is fast
  and deterministic.
