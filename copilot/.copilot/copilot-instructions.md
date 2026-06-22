# Global Agent Instructions

Personal preferences and conventions that apply across all projects.

---

## Decision Framework

Evaluate every solution against:
1. **Correctness**: Does it solve the actual problem?
2. **Security**: Does it introduce vulnerabilities?
3. **Performance**: Is it efficient at scale?
4. **Maintainability**: Can others understand and modify it?
5. **Testability**: Can behavior be verified?

---

## Clean Code Standards

### Naming & Comments
- Names must reveal intent (`isExpired` vs `flag`).
- Comments must explain *why*, not *what*.
- Delete any comment that just repeats the code.
- If a comment explains *what* a block does, delete the comment and extract the block into a well-named function.

### Code Quality
- Guard clauses: flatten nested ifs (`if (error) return;`).
- Single responsibility: split large functions.
- Validate all inputs.
- Explicit over implicit: readable code over clever one-liners.
- Prefer editing existing files over creating new ones.

### Java
- Prefer `var` for local variable declarations where the type is clear from context (Palantir style).
  - Good: `var result = someService.compute();`
  - Avoid: `SomeComplexType result = someService.compute();`

---

## Testing Standards

**Guiding principle:** Unit tests verify logic in isolation; integration tests verify that the pieces work together.

### Unit Tests (default)
- Write unit tests for every discrete piece of logic.
- Mock all external dependencies (databases, APIs, file system, clocks). A unit test must not depend on infrastructure.
- Each test asserts one behavior. If a test breaks, the failure must immediately tell you *what* broke.
- Test names follow Given-When-Then and describe behavior, not implementation:
    - Good: `givenEmptyRepository_whenSearching_thenReturnsEmptyList`
    - Bad: `test_query_method`
- No logic in test setup. Extract complex setup into clearly named factory or builder helpers.

### Integration Tests (targeted, not exhaustive)
- Write a small number of integration tests that exercise the end-to-end path of the change — enough to confirm the wired-together system behaves correctly.
- Do not duplicate what unit tests already prove. Integration tests cover the seams, not the logic.

### Expanding Existing Tests
- If a change logically extends existing behavior, expand the existing test rather than creating a parallel one.
- When modifying a function or module, audit its current tests first. Close coverage gaps in the same commit.
- Never leave a passing test that no longer reflects actual behavior after a refactor.
- Do not mock what can be tested cheaply with real code.

---

## Security
- Never hardcode secrets; use environment variables.
- Treat all external input as untrusted.
- Do not log secrets, tokens, credentials, or personal data.

---

## Dependencies
- Prefer the standard library, then existing project dependencies, before introducing new ones.
- Do not add dependencies for small utilities unless clearly justified.

---

## Error Handling
- No silent failures — errors must surface, not be swallowed.
- Prefer explicit error types over generic exceptions.
- Never use exceptions for control flow.
- Always handle the unhappy path before the happy path.

---

## Refactor Guidelines

When making any refactor (add/remove/rename/change behavior), keep the system consistent and verifiable:
- Update test data, fixtures, and helpers that rely on the old structure or behavior.
- Update mapping/serialization expectations and contract-level checks.
- Update API/integration tests that assert the changed surface.
- Update mocks, stubs, and test builders that construct or validate the changed parts.
- Update documentation or examples that describe the old behavior.
