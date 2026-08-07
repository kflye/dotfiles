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

## Before adding a test — do this first, every time

Duplicate, overlapping, and parallel-instead-of-extended tests all come from
writing a test before looking at the ones that exist. This step is not optional;
producing its output is how you prove you did it.

1. Find the unit under test's existing tests and read the whole class — not just
   the method you happen to be near.
2. Inventory what is already covered: one line per existing test, its name and
   what its body actually asserts. Read the body; names lie.
3. Place the new behavior against that inventory and pick exactly one:
   - **Already covered** → add nothing; say so.
   - **A parameterized/data-driven test covers this shape** → add a data row, not
     a new method.
   - **Extends an existing behavior** → extend that test.
   - **Genuinely new behavior owned by this layer** → new method.
4. State the choice and the target test out loud before writing. If you cannot
   name where it belongs, you skipped steps 1–2 — go back.

Default to extending. A new test method is the exception you justify, not the
reflex you reach for.

## Avoiding overlap and fiction

- **No duplicates.** A new test must differ from every sibling in its *setup* or
  its *assertions*. If both match another test, it is a duplicate — delete it or
  parameterize, no matter how differently it is named.
- **Test at the owning layer.** Verify a behavior once, at the layer that owns
  it; don't re-assert the same behavior from an outer layer. Duplicated
  cross-layer coverage breaks in two places on one change, and the outer copy
  usually proves less than its name suggests.
- **Mocks stay faithful to the real collaborator.** Never stub a dependency to
  return or fail in a way the real one cannot. A test that is green only because
  a stub produced an impossible result verifies a fiction, not the system.
- **Names must match bodies.** A test you are writing now is named for what its
  body asserts. When an *existing* test's name and body disagree, do not silently
  rename or rewrite it — surface it with your reading: the mismatch usually means
  either a stale name or, more importantly, a name promising coverage the body
  never exercises (a gap or a misplaced test). Which side is wrong is the user's
  call; renaming to fit a weak body only hides the gap.

## After writing — verify, don't assume

- Compare the new test against its siblings one more time: identical structure
  means merge them.
- Keep every passing test honest: after a refactor, a test that no longer
  reflects real behavior is updated to match it, not left green.
- Test cheaply with real code rather than mocking it where the real thing is fast
  and deterministic.
